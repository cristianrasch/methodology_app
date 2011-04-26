require 'net/ssh'

class User < ActiveRecord::Base

  USERNAME_REGEXP = /\A[a-z]{3}\z/

  class Position
    MANAGER = 1
    BOSS = 2
    OTHER = 3
    
    SELECT = [[MANAGER, 'Gerente'], [BOSS, 'Jefe'], [OTHER, 'Otro']]
    
    arr = constants.map(&:to_s)
    arr.pop
    arr.each do |position|
      User.class_eval do
        scope position.downcase.pluralize, where(:position => "User::Position::#{position}".constantize).order(:username)
      end
    end
  end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :trackable, 
  # :registerable, :recoverable and :timeoutable
  devise :database_authenticatable, :rememberable, :validatable
  
  has_many :dev_projects, :foreign_key => :dev_id
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :comments
  
  validates :username, :length => {:is => 3}, :uniqueness => true
  validates :name, :presence => true

  scope :devs, where(:username => Conf.devs.split(',')).order(:name)
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :org_unit, :position, :email, :password, :password_confirmation, :remember_me
  
  class << self
    def import
      users = fetch_prod_users
      # vas:x:2772:1002:Vanesa Spaccavento, Marketing:/consejo/acct/vas:/sbin/sh
      users.map! {|user| user.split ':'}
      user_ids = users.map {|arr| arr.first}.select {|user_id| user_id =~ USERNAME_REGEXP}
      curr_users = where(:username => user_ids).all.map(&:username)
      user_ids -= curr_users
      users_hash = users.index_by {|arr| arr.first}
      user_ids.each {|user_id|      
        name, org_unit = users_hash[user_id][4].split(/,\s?/)
        next unless name        
        email_prefix = name.first.downcase+name.split(/\s/).last.downcase
        email = email_prefix+'@consejo.org.ar'
        user = User.new :name => name, :email => email, :password => email_prefix+'123', :org_unit => org_unit
        user.username = user_id
        user.save
      }
    end
    
    def it_staff
      User.where(:org_unit => ['sistemas', 'Desarrollo', 'Gerencia de Sistemas']).
          order(:name).
          select {|user| 
        user.username.match USERNAME_REGEXP
      }
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
  
end
