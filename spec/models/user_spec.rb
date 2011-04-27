require 'spec_helper'

describe User do
  
  it "should only save valid instances" do
    user = User.new
    user.should_not be_valid
    
    user.should have(1).error_on(:username)
    user.should have(1).error_on(:name)
    user.should have(1).error_on(:email)
    user.should have(1).error_on(:password)
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
  
  it "should find users by position" do
    user = Factory(:user)
    User.others.should_not be_empty
    user.update_attribute(:position, User::Position::BOSS)
    User.bosses.should_not be_empty
    user.update_attribute(:position, User::Position::MANAGER)
    User.managers.should_not be_empty
  end
  
  it "should be able to tell when a user is a dev" do
    nondev = Factory(:user)
    nondev.should_not be_a_dev
    dev = Factory(:user, :username => 'crr')
    dev.should be_a_dev
  end
  
end
