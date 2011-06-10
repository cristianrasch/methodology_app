require 'spec_helper'

describe VersionsController do
  render_views
  
  before do 
    @current_user = Factory(:user)
    sign_in @current_user
    
    @project = Factory(:project, :estimated_start_date => Date.tomorrow)
    Factory(:project, :dev => @project.dev, :estimated_start_date => 2.days.from_now.to_date)
  end

  it "should list project's rescheduled envisaged end dates" do
    get :project, :id => @project
    
    response.should be_success
    response.should render_template(:project)
    assigns[:project].should_not be_nil
    # assigns[:project].versions.should have(2).versions
  end
end
