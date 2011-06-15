require 'spec_helper'

describe EventsController do
  render_views
  
  before do 
    @current_user = Factory(:user)
    sign_in @current_user
  end

  it "should render the index action" do
    get :index, :project_id => Factory(:project)
    
    response.should be_success
    response.should render_template('index')
    assigns[:project].should_not be_nil
    assigns[:events].should_not be_nil
  end

  it "should render the new action" do
    get :new, :project_id => Factory(:project)
    
    response.should be_success
    response.should render_template('new')
    assigns[:project].should_not be_nil
    assigns[:event].should_not be_nil
  end
  
  context "create action" do
    it "should render the new action when invalid params supplied" do
      lambda {
        post :create, :project_id => Factory(:project), :event => {}
      }.should_not change(Event, :count)
      
      response.should be_success
      response.should render_template('new')
      assigns[:project].should_not be_nil
      assigns[:event].should_not be_nil
      assigns[:event].should_not be_valid
    end
    
    it "should create a new event when valid params supplied" do
      lambda {
        post :create, :project_id => Factory(:project), 
             :event => Factory.attributes_for(:event)
      }.should change(Event, :count).by(1)
      
      response.should be_redirect
      assigns[:event].should_not be_nil
      response.should redirect_to(assigns[:event])
      assigns[:project].should_not be_nil
      flash[:notice].should == "#{Event.model_name.human.humanize} creado"
    end
  end

  %w{show edit}.each do |action|
    it "should render the #{action} action" do
      get action, :id => Factory(:event)
      
      response.should be_success
      response.should render_template(action)
      assigns[:event].should_not be_nil
      assigns[:project].should_not be_nil
    end
  end
  
  context "update action" do
    before do
      @event = Factory(:event)
    end
  
    it "should render the edit action when invalid params supplied" do
      put :update, :id => @event, :event => {:stage => 0}
      
      response.should be_success
      response.should render_template(:edit)
      assigns[:event].should_not be_nil
      assigns[:event].should_not be_valid
    end
    
    it "should update an existing event when valid params supplied" do
      put :update, :id => @event, :event => {:stage => 2}
      
      response.should be_redirect
      response.should redirect_to(@event)
      assigns[:event].should_not be_nil
      flash[:notice].should == "#{Event.model_name.human.humanize} actualizado"
    end
  end
  
  it "should delete an existing event" do
    event = Factory(:event)
    project = event.project
    
    lambda {
      delete :destroy, :id => event
    }.should change(project.events, :count).by(-1)
    
    response.should be_redirect
    response.should redirect_to(project_events_path(project))
    assigns[:event].should_not be_nil
    flash[:notice].should == "#{Event.model_name.human.humanize} eliminado"
  end
end
