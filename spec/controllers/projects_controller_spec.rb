require 'spec_helper'

describe ProjectsController do

  before do 
    @current_user = Factory(:user)
    sign_in @current_user
  end
  
  it "should render the new action" do
    get :index
    
    response.should be_success
    response.should render_template('index')
    assigns[:projects].should_not be_nil
    assigns[:project].should_not be_nil
  end
  
  it "should render the new action" do
    get :new
    
    response.should be_success
    response.should render_template('new')
    assigns[:project].should_not be_nil
    assigns[:project].should be_a_new_record
  end
  
  context "create action" do
    it "should render the new action when invalid params supplied" do
      post :create, :project => {}
      
      response.should be_success
      response.should render_template('new')
      assigns[:project].should_not be_nil
      assigns[:project].should_not be_valid
    end
    
    it "should create a new project when valid params supplied" do
      attrs = Factory.attributes_for(:project, :dev_id => @current_user.id,
                                    :owner_id => Factory(:user).id,  
                                    :user_ids => [Factory(:user).id])
      lambda {
        post :create, :project => attrs
      }.should change(Project, :count).by(1)
      
      response.should be_redirect
      assigns[:project].should_not be_nil
      response.should redirect_to(assigns[:project])
      flash[:notice].should == "#{Project.model_name.human.humanize} creado"
    end
  end
  
  it "should render the show action" do
    get :show, :id => Factory(:project)
    
    response.should be_success
    response.should render_template('show')
    assigns[:project].should_not be_nil
    assigns[:project].should be_valid
  end
  
  it "should render the edit action" do
    get :edit, :id => Factory(:project)
    
    response.should be_success
    response.should render_template('edit')
    assigns[:project].should_not be_nil
    assigns[:project].should be_valid
  end
  
  context "update action" do
    it "should render the edit action when invalid params supplied" do
      put :update, :id => Factory(:project), :project => {:estimated_duration => 0}
      
      response.should be_success
      response.should render_template('edit')
      assigns[:project].should_not be_nil
      assigns[:project].should_not be_valid
    end
    
    it "should update an existing project when valid params supplied" do
      put :update, :id => Factory(:project), :project => {:estimated_duration => 25}
      
      response.should be_redirect
      assigns[:project].should_not be_nil
      response.should redirect_to(assigns[:project])
      assigns[:project].estimated_duration.should == 25
      flash[:notice].should == "#{Project.model_name.human.humanize} actualizado"
    end
  end
  
  it "should delete an existing project" do
    lambda {
      delete :destroy, :id => Factory(:project)
    }.should_not change(Project, :count)
    
    response.should be_redirect
    response.should redirect_to(projects_path)
    flash[:notice].should == "#{Project.model_name.human.humanize} eliminado"
  end
  
  it "should display the project's library" do
    get :library, :id => Factory(:project)
    
    response.should be_success
    response.should render_template('library')
    assigns[:project].should_not be_nil
  end

end
