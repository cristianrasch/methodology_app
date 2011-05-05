require 'spec_helper'

describe AccountsController do
  render_views
  
  before do 
    @current_user = Factory(:user)
    sign_in @current_user
  end

  it "render the edit action" do
    get :edit
    
    response.should be_success
    response.should render_template('edit')
    assigns[:user].should_not be_nil
    assigns[:user].should == @current_user
  end
  
  context "update action" do
    it "should render the edit action when invalid params supplied" do
      put :update, :user => {:email => 'xxx'}
      
      response.should be_success
      response.should render_template('edit')
      assigns[:user].should_not be_nil
      assigns[:user].should_not be_valid
    end
    
    it "should update user's attrs when invalid params supplied" do
      put :update, :user => {:email => 'someone@consejo.org.ar'}
      
      response.should be_redirect
      response.should redirect_to(root_path)
      assigns[:user].should_not be_nil
      assigns[:user].should be_valid
      flash[:notice].should == 'Cuenta actualizada'
    end
  end
end