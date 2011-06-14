require 'spec_helper'

describe MethodologyController do
  render_views

  before do 
    @current_user = Factory(:user)
    sign_in @current_user
  end

  it "should display methodology's link on CPCECABA's wiki" do
    get :index
    
    response.should be_success
    response.should render_template(:index)
  end
end
