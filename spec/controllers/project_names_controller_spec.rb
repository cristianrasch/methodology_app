require 'spec_helper'

describe ProjectNamesController do
  before { sign_in(find_boss) }  

  it "should deny access to non bosses" do
    sign_in(Factory(:user))
    
    get :index
    response.status.should == 401
    response.body.should == 'Acceso denegado.'
  end
  
  it "should display a list of project names" do
    get :index
    
    response.should be_success
    response.should render_template('index')
    assigns[:project_names].should_not be_nil
  end

  context "new action" do
    it "should display a new ProjectName form" do
      get :new
      
      response.should be_success
      response.should render_template('new')
      assigns[:project_name].should_not be_nil
      assigns[:project_names].should_not be_nil
    end
    
    it "should not load root project names when a parent_id is specified" do
      get :new, :parent_id => Factory(:project_name)
      
      response.should be_success
      response.should render_template('new')
      assigns[:project_name].should_not be_nil
      assigns[:project_names].should be_nil
    end
  end

  context "create action" do
    it "should redisplay the new ProjectName form when invalid params supplied" do
      lambda {
        post :create, :project_name => {:text => ''}
      }.should_not change(ProjectName, :count)
      
      response.should be_success
      response.should render_template('new')
      assigns[:project_name].should_not be_nil
      assigns[:project_names].should_not be_nil
    end
    
    it "should create a new ProjectName when valid params supplied" do
      lambda {
        post :create, :project_name => {:text => 'zz'}
      }.should change(ProjectName, :count).by(1)
      
      response.should be_redirect
      assigns[:project_name].should_not be_nil
      response.should redirect_to(assigns[:project_name])
      flash[:notice].should == "#{ProjectName.model_name.human.humanize} creado"
    end
  end

  it "should display a ProjectName's page" do
    get :show, :id => Factory(:project_name)
    
    response.should be_success
    response.should render_template('show')
    assigns[:project_name].should_not be_nil
    assigns[:project_name].should be_valid
  end

  it "should display ProjectName's edit page" do
    get :edit, :id => Factory(:project_name)
    
    response.should be_success
    response.should render_template('edit')
    assigns[:project_name].should_not be_nil
    assigns[:project_name].should be_valid
    assigns[:project_names].should_not be_nil
  end

  context "update action" do
    it "should redisplay ProjectName's edit page when invalid params supplied" do
      put :update, :id => Factory(:project_name), :project_name => {:text => ''}
      
      response.should be_success
      response.should render_template('edit')
      assigns[:project_name].should_not be_nil
      assigns[:project_name].should_not be_valid
      assigns[:project_names].should_not be_nil
    end
    
    it "should update a ProjectName record when valid params supplied" do
      put :update, :id => Factory(:project_name), :project_name => {:text => 'qq'}
      
      response.should be_redirect
      assigns[:project_name].should_not be_nil
      response.should redirect_to(assigns[:project_name])
      assigns[:project_name].should be_valid
      flash[:notice].should == "#{ProjectName.model_name.human.humanize} actualizado"
    end
  end

  it "should delete a ProjectName record" do
    lambda {
      delete :destroy, :id => Factory(:project_name)
    }.should_not change(ProjectName, :count)
    
    response.should be_redirect
    response.should redirect_to(project_names_path)
    flash[:notice].should == "#{ProjectName.model_name.human.humanize} eliminado"
  end
end
