require 'net/ssh'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :trackable, 
  # :registerable, :recoverable and :timeoutable
  devise :database_authenticatable, :rememberable, :validatable
  
  has_many :projects, :foreign_key => :dev_id
  
  validates :username, :length => {:is => 3}, :uniqueness => true
  validates :name, :presence => true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :org_unit, :email, :password, :password_confirmation, :remember_me
  
  class << self
    def import
      users = fetch_prod_users
      # vas:x:2772:1002:Vanesa Spaccavento, Marketing:/consejo/acct/vas:/sbin/sh
      users.map! {|user| user.split ':'}
      user_ids = users.map {|arr| arr.first}
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
    
    def devs
      User.where(:username => Conf.devs.split(',')).order(:username)
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
