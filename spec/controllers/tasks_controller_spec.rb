require 'spec_helper'

describe TasksController do
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
    assigns[:tasks].should_not be_nil
  end
  
  it "should render the new action" do
    get :new, :project_id => Factory(:project)
    
    response.should be_success
    response.should render_template('new')
    assigns[:project].should_not be_nil
    assigns[:task].should_not be_nil
  end
  
  context "create action" do
    it "should render the new action when invalid params supplied" do
      lambda {
        post :create, :project_id => Factory(:project), :task => {}
      }.should_not change(Task, :count)
      
      response.should be_success
      response.should render_template('new')
      assigns[:project].should_not be_nil
      assigns[:task].should_not be_nil
      assigns[:task].should_not be_valid
    end
    
    it "should create a new task when valid params supplied" do
      lambda {
        post :create, :project_id => Factory(:project), 
             :task => Factory.attributes_for(:task).merge(:owner_id => User.first.id)
      }.should change(Task, :count).by(1)
      
      response.should be_redirect
      assigns[:task].should_not be_nil
      assigns[:task].author.should == @current_user
      response.should redirect_to(assigns[:task])
      assigns[:project].should_not be_nil
      flash[:notice].should == "#{Task.model_name.human.humanize} creada"
    end
  end
  
  %w{show edit}.each do |action|
    it "should render the #{action} action" do
      get action, :id => Factory(:task)
      
      response.should be_success
      response.should render_template(action)
      assigns[:task].should_not be_nil
    end
  end
  
  context "update action" do
    before do
      @task = Factory(:task)
    end
  
    it "should render the edit action when invalid params supplied" do
      put :update, :id => @task, :task => {:description => ''}
      
      response.should be_success
      response.should render_template(:edit)
      assigns[:task].should_not be_nil
      assigns[:task].should_not be_valid
    end
    
    it "should update an existing task when valid params supplied" do
      put :update, :id => @task, :task => {:description => 'xxx'}
      
      response.should be_redirect
      response.should redirect_to(@task)
      assigns[:task].should_not be_nil
      flash[:notice].should == "#{Task.model_name.human.humanize} actualizada"
    end
  end
  
  it "should delete an existing task" do
    task = Factory(:task)
    project = task.project
    
    lambda {
      delete :destroy, :id => task
    }.should change(project.tasks, :count).by(-1)
    
    response.should be_redirect
    response.should redirect_to(project_tasks_path(project))
    assigns[:task].should_not be_nil
    flash[:notice].should == "#{Task.model_name.human.humanize} eliminada"
  end
end
