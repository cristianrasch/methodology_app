require 'spec_helper'

describe SearchController do
  render_views
  
  before do 
    @current_user = Factory(:user)
    sign_in @current_user
  end
  
  it "should search for projects" do
    get :projects, :project => {}
    
    response.should be_success
    response.should render_template('projects/index')
    assigns[:project].should_not be_nil
    assigns[:projects].should_not be_nil
  end
end
