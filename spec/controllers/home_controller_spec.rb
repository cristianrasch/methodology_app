require 'spec_helper'

describe HomeController do
  render_views
  
  it "should render the index action" do
    get :index
    
    response.should be_success
    response.should render_template('index')
  end
end
