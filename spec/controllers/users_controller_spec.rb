require 'spec_helper'

describe UsersController do
  render_views
  
  before { sign_in(find_boss) }
  
  it "should return a list of users matching the given name" do
    sign_in(Factory(:user, :name => 'Mr. Bean'))
    xhr :get, :index, :format => :json, :q => 'bea'
    
    response.should be_success
    assigns[:users].should_not be_nil
    assigns[:users].should have(1).user
  end
  
  it "should display a list of existing users" do
    get :index
    
    response.should be_success
    response.should render_template(:index)
    assigns[:users].should_not be_nil
  end
  
  it "should display a new User form" do
    get :new
    
    response.should be_success
    response.should render_template(:new)
    assigns[:user].should_not be_nil
  end
  
  context "create action" do
    it "should redisplay the new User form when invalid params are submitted" do
      lambda {
        post :create, :user => {}
      }.should_not change(User, :count)
      
      response.should be_success
      response.should render_template(:new)
      assigns[:user].should_not be_nil
      assigns[:user].should_not be_valid
    end
    
    it "should create a new User when valid params are submitted" do
      lambda {
        post :create, :user => Factory.attributes_for(:user), :username => 'xxx'
      }.should change(User, :count).by(1)
      
      response.should be_redirect
      assigns[:user].should_not be_nil
      response.should redirect_to(assigns[:user])
      flash[:notice].should == "#{User.model_name.human.humanize} creado"
    end
  end

  it "should display User's page" do
    get :show, :id => Factory(:user)
    
    response.should be_success
    response.should render_template(:show)
    assigns[:user].should_not be_nil
    assigns[:user].should be_valid
  end
  
  it "should display User's edit form" do
    get :edit, :id => Factory(:user)
    
    response.should be_success
    response.should render_template(:edit)
    assigns[:user].should_not be_nil
  end
  
  context "update action" do
    it "should redisplay User's edit form when invalid params are submitted" do
      put :update, :id => Factory(:user), :user => {:email => ''}
      
      response.should be_success
      response.should render_template(:edit)
      assigns[:user].should_not be_nil
      assigns[:user].should_not be_valid
    end
    
    it "should update an existing User when valid params are submitted" do
      put :update, :id => Factory(:user), :user => {:email => 'xxx@consejo.org.ar'}
      
      response.should be_redirect
      assigns[:user].should_not be_nil
      response.should redirect_to(assigns[:user])
      flash[:notice].should == "#{User.model_name.human.humanize} actualizado"
    end
  end
  
  context "destroy action" do
    it "should not delete developers" do
      dev = find_dev
      lambda {
        delete :destroy, :id => dev
      }.should_not change(User, :count)
      
      response.should be_success
      response.should render_template(:show)
      assigns[:user].should_not be_nil
      assigns[:user].should_not be_destroyed
      flash.now[:alert].should == 'No es posible eliminar desarrolladores'
    end
    
    it "should delete non-dev users" do
      lambda {
        delete :destroy, :id => Factory(:user)
      }.should_not change(User, :count)
      
      response.should be_redirect
      response.should redirect_to(users_path)
      assigns[:user].should_not be_nil
      assigns[:user].should be_destroyed
      flash[:notice].should == "#{User.model_name.human.humanize} eliminado"
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    
    if @user.delete
      redirect_to(users_path, :notice => "#{User.model_name.human.humanize} eliminado")
    else
      flash.now[:alert] = 'No es posible eliminar desarrolladores'
      render :show
    end
  end
end
