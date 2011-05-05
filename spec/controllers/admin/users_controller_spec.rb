require 'spec_helper'

describe Admin::UsersController do
  render_views
  
  context "users import" do
    it "should deny access to non admin users" do
      admin_login :passwd => '123'
      post :import
      
      response.should_not be_success
      response.code.should =~ /401/
    end
    
    it "should allow access to admin users" do
      admin_login
      stub_users_fetching
      post :import
      
      response.should be_success
      response.body.should == 'done.'
    end
  end
end
