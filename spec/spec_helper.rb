# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  
  config.include Devise::TestHelpers, :type => :controller
end

def stub_users_fetching
  prod_users = ["asm:x:2772:1002:Mr XAX, sistemas:/consejo/acct/vas:/sbin/sh",
                "cas:x:2772:1002:Mr ZAZ, sistemas:/consejo/acct/vas:/sbin/sh"]
  User.stub!(:fetch_prod_users).and_return(prod_users)
end

def admin_login(user = nil, passwd = nil)
  credentials = *Conf.admin_users.first
  user ||= credentials.first
  passwd ||= credentials.last
  request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, passwd)
end

def find_dev(username = 'crr')
  User.find_by_username(username) || Factory(:user, :username => username)
end

def find_boss(username = 'gar')
  User.find_by_username(username) || Factory(:user, :username => username)
end

def build_model(model, attrs)
  m = Factory.build(model)
  attrs.each { |k, v| m.send("#{k}=", v) }
  m
end

def create_model(model, attrs)
  m = Factory.build(model)
  attrs.each { |k, v| m.send("#{k}=", v) }
  m.save!
  m
end

def test_file(file = 'robots.txt')
  File.open(File.join(Rails.public_path, file))
end

