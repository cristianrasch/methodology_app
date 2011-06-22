require 'net/ssh'

class User < ActiveRecord::Base

  extend ArrayUtils

  USERNAME_REGEXP = /\A[a-z]{3}\z/

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :registerable, 
  # :recoverable, :validatable and :timeoutable
  devise :database_authenticatable, :rememberable, :trackable
  
  validates :username, :presence => true, :uniqueness => true
  validates_length_of :username, :is => 3 if Rails.env.production?
  
  validates :name, :presence => true
  
  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :on => :update
  validates_uniqueness_of :email, :on => :update
  
  validates :password, :length => {:within => 6..20 }, 
            :if => Proc.new { |user| user.new_record? || user.encrypted_password_changed? }
  validates_confirmation_of :password, :if => :encrypted_password_changed?, :on => :update
  
  validates_presence_of :password_confirmation, :if => :encrypted_password_changed?, :on => :update
  
  has_many :dev_projects, :class_name => 'Project', :foreign_key => :dev_id
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :comments

  scope :devs, where(:username => Conf.devs.split(',')).order(:name)
  scope :nondevs, where(:username - Conf.devs.split(',')).order(:name)
  scope :ordered, order(:name)
  scope :potential_owners, where(:potential_owner => true).order(:name)
  scope :devs_who_have_not_signed_in_since_last_week, lambda { where(:username => Conf.devs.split(',')).
                                                               where(:last_sign_in_at < 1.week.ago) }
  
  attr_writer :source
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :org_unit, :position, :email, :password, :password_confirmation, :remember_me,
                  :potential_owner
  
  before_create :format_name
  before_save :titleize_name
  
  class << self
    def import
      users = fetch_prod_users
      # vas:x:2772:1002:Vanesa Spaccavento, Marketing:/consejo/acct/vas:/sbin/sh
      users.map! {|user| user.split ':'}
      user_ids = users.map {|arr| arr.first}.select {|user_id| user_id =~ USERNAME_REGEXP && app_user?(user_id)}
      curr_users = where(:username => user_ids).all.map(&:username)
      user_ids -= curr_users
      users_hash = users.index_by {|arr| arr.first}
      user_ids.each {|user_id|      
        name, org_unit = users_hash[user_id][4].split(/,\s?/)
        next unless name
        user = User.new :name => name, :org_unit => org_unit, :password => "#{user_id}123"
        user.username = user_id
        user.source = :unix
        user.save
      }
    end
    
    def it_staff(options = {})
      users =  User.where(:org_unit => ['sistemas', 'Desarrollo', 'Gerencia de Sistemas']).order(:name)
      users = users.where(:username - to_a(options[:except]).map(&:username)) if options.has_key?(:except)
      users.select {|user| user.username.match(USERNAME_REGEXP)}
    end
    
    def app_user?(username)
      Conf.devs.split(',').include?(username) or Conf.bosses.split(',').include?(username) or Conf.potential_owners.split(',').include?(username)
    end
    
    def notify_devs_who_have_not_signed_in_since_last_week
      devs_who_have_not_signed_in_since_last_week.each { |dev|
        Notifications.has_not_signed_in_since_last_week(dev).deliver
      }
    end
    
    def authenticate_by_session_id(session_id)
      if session_id.present?
        auth_query = <<SQL
  select first 1 trim(usuario) username 
    from session s 
    where s.sessionid = ? and 
          fecha = today and 
          exists(select 1 
                  from rol r 
                  where r.codusuario = s.usuario and 
                        r.codigosistema = ? and 
                        r.funcion = ?) 
    order by nrosession desc
SQL
        hash = Informix.connect(Conf.ifx['db'], Conf.ifx['user'], Conf.ifx['passwd']) do |db|
          db.prepare(auth_query) {|stmt| stmt.execute(session_id, Conf.app['code'], Conf.app['role']) }
        end
        
        User.find_by_username(hash["username"]) unless hash.empty?
      end
    end
    
    private
    
    def fetch_prod_users
      users = []
      Net::SSH.start(Conf.produ['ip'], Conf.produ['user'], :password => Conf.produ['passwd']) do |ssh|
        users = ssh.exec!("cat /etc/passwd").split("\n")
      end
      users
    end
  end
  
  def password_required?
    new_record?
  end
  
  %w{dev boss}.each do |method|
    define_method("#{method}?".to_sym) do
      Conf.send(method.pluralize).split(',').include?(username)
    end
  end
  
  def to_s
    name
  end
  
  def delete
    if dev?
      false
    else
      super
    end
  end
  
  private
  
  def format_name
    if @source == :unix
      i = name.rindex(' ')
      if i
        i += 1
        self.name = name[i,name.length-i]+', '+name[0,i-1]
      end
    end
  end
  
  def titleize_name
    self.name = name.titleize
  end
end
