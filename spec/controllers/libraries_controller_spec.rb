require 'spec_helper'

describe LibrariesController do
  before do 
    sign_in(find_boss)
    Factory(:project)
    2.times { Factory(:document) }
  end
  
  it "should display Projects' library page" do
    get :index
    
    response.should be_success
    response.should render_template(:index)
    assigns[:projects].should_not be_empty
    assigns[:projects].should have(2).projects
  end
end
