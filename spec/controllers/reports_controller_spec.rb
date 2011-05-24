require 'spec_helper'

describe ReportsController do
  render_views
  
  before { sign_in(find_boss) }

  it "should deny access to non bosses" do
    sign_in(find_dev)
    get :index
    
    response.status.should == 401
    response.body.should == 'Acceso denegado.'
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
    assigns[:report].should_not be_nil
    assigns[:data].should_not be_nil
  end
end
