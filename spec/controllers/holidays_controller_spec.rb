require 'spec_helper'

describe HolidaysController do
  render_views
  
  before { sign_in(find_boss) }
  
  it "should display a list of this year's holidays" do
    get :index
    
    response.should be_success
    response.should render_template('index')
    assigns[:holidays].should_not be_nil
  end
  
  it "should display a new holiday form" do
    get :new
    
    response.should be_success
    response.should render_template('new')
    assigns[:holiday].should_not be_nil
  end
  
  context "create action" do
    it "should redisplay the new holiday form when invalid params supplied" do
      lambda {
        post :create, :holiday => {}
      }.should_not change(Holiday, :count)
      
      response.should be_success
      response.should render_template('new')
      assigns[:holiday].should_not be_nil
      assigns[:holiday].should_not be_valid
    end
    
    it "should create a new holiday form when valid params supplied" do
      lambda {
        post :create, :holiday => Factory.attributes_for(:holiday)
      }.should change(Holiday, :count).by(1)
      
      response.should be_redirect
      response.should redirect_to(holidays_path)
      assigns[:holiday].should_not be_nil
      flash[:notice].should == "#{Holiday.model_name.human.humanize} creado"
    end
  end
  
  it "should display holiday's edit form" do
    get :edit, :id => Factory(:holiday)
    
    response.should be_success
    response.should render_template('edit')
    assigns[:holiday].should_not be_nil
    assigns[:holiday].should be_valid
  end
  
  context "update action" do
    it "should redisplay holiday's edit form when invalid params supplied" do
      put :update, :id => Factory(:holiday), :holiday => {:name => ''}
      
      response.should be_success
      response.should render_template('edit')
      assigns[:holiday].should_not be_nil
      assigns[:holiday].should_not be_valid
    end
    
    it "should update an existing holiday when valid params supplied" do
      put :update, :id => Factory(:holiday), :holiday => {:name => '..'}
      
      response.should be_redirect
      response.should redirect_to(holidays_path)
      assigns[:holiday].should_not be_nil
      assigns[:holiday].should be_valid
      flash[:notice].should == "#{Holiday.model_name.human.humanize} actualizado"
    end
  end
  
  it "should delete a holiday" do
    lambda {
      delete :destroy, :id => Factory(:holiday)
    }.should_not change(Holiday, :count)
    
    response.should be_redirect
    response.should redirect_to(holidays_path)
    flash[:notice].should == "#{Holiday.model_name.human.humanize} eliminado"
  end
end
