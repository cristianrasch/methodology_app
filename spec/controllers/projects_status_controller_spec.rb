require 'spec_helper'

describe ProjectsStatusController do

  before do 
    @current_user = Factory(:user)
    sign_in @current_user
  end

  it "should display a list of projects based on the supplied params" do
    dev = Factory(:user)
    Factory(:project, :dev => dev, :estimated_start_date => Date.tomorrow)
    get :index, :dev_id => dev.id, :indicator => Project::Indicator::YELLOW
    
    response.should be_success
    response.should render_template('index')
    assigns[:project].should_not be_nil
    assigns[:projects].should_not be_nil
    assigns[:projects].should_not be_empty
  end

end
