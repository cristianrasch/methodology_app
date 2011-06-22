require 'spec_helper'
require 'informix'

describe User do
  context "model validations" do
    it "should validate new instances" do
      user = User.new
      user.should_not be_valid
      
      user.should have(1).error_on(:username)
      user.should have(1).error_on(:name)
      user.should have(1).error_on(:password)
    end
    
    it "should validate mass-imported instances" do
      user = User.new :name => 'Mr X', :password => 'pass123'
      user.username = 'xxx'
      user.save!
      
      user.should_not be_valid
      user.should have(1).error_on(:email)
    end
  end
  
  it "should format user's name properly" do
    rms = Factory.build(:user, :name => 'Richard Matthew Stallman')
    rms.source = :unix
    rms.save
    rms.name.should == 'Stallman, Richard Matthew'
  end
  
  it "should import production users" do
    stub_users_fetching
    
    lambda {
      User.import
    }.should change(User, :count).by(2)
  end
  
  it "should return an array of devs" do
    %w{crr fol pap}.each_with_index { |user, i| Factory(:user, :username => user, :email => "#{user}@consejo.org.ar") }
    3.times { |i| Factory(:user, :username => "mr#{i}", :email => "nodev#{i}@consejo.org.ar") }
    User.devs.should have(3).records
  end
  
  it "should return an array of IT staff" do
    users = []
    %w{gbe mpa}.each { |user| users << Factory(:user, :username => user, :org_unit => 'sistemas') }
    3.times { Factory(:user) }
    User.it_staff.should have(2).records
    User.it_staff(:except => users.first).should have(1).record
  end
  
  it "should be able to tell when a user is a dev" do
    Factory(:user).should_not be_a_dev
    Factory(:user, :username => 'crr').should be_a_dev
  end
  
  it "should be able to tell when a user is a boss" do
    Factory(:user).should_not be_a_boss
    Factory(:user, :username => 'gar').should be_a_boss
  end
  
  it "should identify app users" do
    User.app_user?('gbe').should be_true
    User.app_user?('mev').should be_true
    User.app_user?('crg').should be_true
    User.app_user?('xxx').should be_false
  end
  
  it "should not delete developers" do
    dev = find_dev
    dev.delete
    dev.should be_persisted
    user = Factory(:user)
    user.delete
    user.should be_destroyed
  end
  
  context do "dev's notifications"
    it "should notify users who have not signed in since last week" do
      devs = []
      %w[crr gbe].each { |dev| 
        devs << Factory(:user, :username => dev, :last_sign_in_at => 1.month.ago)
      }
      
      lambda {
        User.notify_devs_who_have_not_signed_in_since_last_week
      }.should change(ActionMailer::Base.deliveries, :length).by(devs.length)
      ActionMailer::Base.deliveries[-1].to.should include(devs.last.email)
      ActionMailer::Base.deliveries[-2].to.should include(devs.first.email)
    end
  end
  
  context "session_id authentication" do
    it "should return nil when an invalid session_id param is supplied" do
      User.authenticate_by_session_id(nil).should be_nil
    end
    
    it "should return a User object when a valid session_id param is supplied" do
      session_id, username = '123', 'crr'
      Informix.connect(Conf.ifx['db'], Conf.ifx['user'], Conf.ifx['passwd']) do |db|
        stmt = db.prepare('insert into session(sessionid,sistema,fecha,hora,usuario,terminal) values(?,?,today,?,?,?)')
        stmt[session_id,'',1234,username,'WEB']
      end
      User.authenticate_by_session_id(session_id).should == User.find_by_username(username)
    end
  end
end
