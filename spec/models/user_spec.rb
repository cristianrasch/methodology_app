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
end
