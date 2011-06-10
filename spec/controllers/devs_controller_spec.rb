require 'spec_helper'

describe DevsController do
  render_views
  
  before { sign_in(find_boss) }

  it "should return an XML representation of dev's on course or pending projects" do
    dev = find_dev
    stopped_project = Factory(:project, :dev => dev)
    stopped_project.update_attributes(:status => Project::Status::CANCELED, :updated_by => dev.id)
    on_course_project = Factory(:project, :dev => dev)
    on_course_project.update_attributes(:status => Project::Status::IN_DEV, :updated_by => dev.id)
    2.times { |i| Factory(:project, :dev => dev, :estimated_start_date => i.weeks.from_now.to_date) }  
    get :projects, :id => dev, :format => :xml
    
    response.should be_success
    response.should render_template(:projects)
    assigns[:dev].should_not be_nil
    assigns[:on_course_projects].should_not be_nil
    assigns[:on_course_projects].should_not be_empty
    assigns[:on_course_projects].should_not include(stopped_project)
    assigns[:pending_projects].should_not be_nil
    assigns[:pending_projects].should_not be_empty
    assigns[:pending_projects].should_not include(stopped_project)
    assigns[:today].should_not be_nil
    assigns[:today].should == Date.today
  end
end
