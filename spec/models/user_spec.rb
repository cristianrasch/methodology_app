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
end
