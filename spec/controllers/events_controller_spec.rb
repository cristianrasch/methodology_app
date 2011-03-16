require 'spec_helper'

describe EventsController do

  before do 
    @current_user = Factory(:user)
    sign_in @current_user
    @project = Factory(:project, :owner => @current_user, :dev => @current_user)
  end

  it "should render the index action" do
    get :index, :project_id => @project
    
    response.should be_success
    response.should render_template('index')
    assigns[:project].should_not be_nil
    assigns[:events].should_not be_nil
  end

  it "should render the new action" do
    get :new, :project_id => @project
    
    response.should be_success
    response.should render_template('new')
    assigns[:project].should_not be_nil
    assigns[:event].should_not be_nil
  end
  
  context "create action" do
    it "should render the new action when invalid params supplied" do
      lambda {
        post :create, :project_id => @project, :event => {}
      }.should_not change(@project.events, :count)
      
      response.should be_success
      response.should render_template('new')
      assigns[:project].should_not be_nil
      assigns[:event].should_not be_nil
      assigns[:event].should_not be_valid
    end
    
    it "should create a new event when valid params supplied" do
      lambda {
        post :create, :project_id => @project, 
             :event => Factory.attributes_for(:event)
      }.should change(@project.events, :count).by(1)
      
      response.should be_redirect
      assigns[:event].should_not be_nil
      response.should redirect_to([@project, assigns[:event]])
      assigns[:project].should_not be_nil
      flash[:notice].should == "#{Event.model_name.human.humanize} creado"
    end
  end

  %w{show edit}.each do |action|
    it "should render the #{action} action" do
      event_attrs = Factory.attributes_for(:event, :author => @current_user)
      event = @project.events.create(event_attrs)
      get action, :project_id => @project, :id => event
      
      response.should be_success
      response.should render_template(action)
      assigns[:project].should_not be_nil
      assigns[:event].should_not be_nil
    end
  end
  
  it "should delete an existing event" do
    event_attrs = Factory.attributes_for(:event, :author => @current_user)
    event = @project.events.create(event_attrs)
    
    lambda {
      delete :destroy, :project_id => @project, :id => event
    }.should change(@project.events, :count).by(-1)
    
    response.should be_redirect
    response.should redirect_to(project_events_path(@project))
    assigns[:project].should_not be_nil
    assigns[:event].should_not be_nil
    flash[:notice].should == "#{Event.model_name.human.humanize} eliminado"
  end

end
