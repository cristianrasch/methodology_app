require 'spec_helper'

describe DevsController do
  render_views
  
  before { sign_in(find_boss) }

  it "should return an XML representation of dev's on course or pending projects" do
    dev = find_dev
    2.times { |i| Factory(:project, :dev => dev, :estimated_start_date => i.months.ago.to_date) }  
    get :projects, :id => dev, :format => :xml
    
    response.should be_success
    response.should render_template(:projects)
    assigns[:dev].should_not be_nil
    assigns[:projects].should_not be_nil
  end
end
