require 'net/ssh'

class User < ActiveRecord::Base

  extend ArrayUtils

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
  # :registerable, :recoverable, :validatable and :timeoutable
  devise :database_authenticatable, :rememberable
  
  has_many :dev_projects, :foreign_key => :dev_id
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :comments
  
  validates :username, :presence => true, :uniqueness => true
  validates_length_of :username, :is => 3 if Rails.env == 'production'
  
  validates :name, :presence => true
  
  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :on => :update
  validates_uniqueness_of :email, :on => :update
  
  validates :password, :length => {:within => 6..20 }, 
            :if => Proc.new { |user| user.new_record? || user.encrypted_password_changed? }
  validates_confirmation_of :password, :if => :encrypted_password_changed?, :on => :update
  
  validates_presence_of :password_confirmation, :if => :encrypted_password_changed?, :on => :update

  scope :devs, where(:username => Conf.devs.split(',')).order(:name)
  scope :nondevs, where(:username - Conf.devs.split(',')).order(:name)
  
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
        user = User.new :name => name, :org_unit => org_unit, :email => nil, :password => "#{user_id}123"
        user.username = user_id
        user.save
      }
    end
    
    def it_staff(options = {})
      users =  User.where(:org_unit => ['sistemas', 'Desarrollo', 'Gerencia de Sistemas']).order(:name)
      users = users.where(:username - to_a(options[:except]).map(&:username)) if options.has_key?(:except)
      users.select {|user| user.username.match(USERNAME_REGEXP)}
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
  
  def dev?
    Conf.devs.split(',').include?(username)
  end
  
end
