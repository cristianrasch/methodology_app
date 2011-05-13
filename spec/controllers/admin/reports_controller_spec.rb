require 'spec_helper'

describe Admin::ReportsController do
  render_views
  
  before { admin_login }

  it "should deny access to non admin users" do
    admin_login :passwd => '123'
    get :index
    
    response.should_not be_success
    response.status.should == 401
  end

  it "should display a list of the available report types" do
    get :index
    
    response.should be_success
    response.should render_template('index')
  end
  
  it "should display a report graph" do
    get :new, :type => Report::Type::WORKLOAD_BY_DEV
    
    response.should be_success
    response.should render_template('new')
    assigns[:type].should == Report::Type::WORKLOAD_BY_DEV
    assigns[:type].should_not be_nil
    assigns[:data].should_not be_nil
  end
end
