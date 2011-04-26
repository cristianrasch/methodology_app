require 'spec_helper'

describe CommentsController do

  before do 
    @current_user = Factory(:user)
    sign_in @current_user
  end
  
  it "should render the index action" do
    get :index, :event_id => Factory(:event)
    
    response.should be_success
    response.should render_template(:index)
    assigns[:commentable].should_not be_nil
    assigns[:comments].should_not be_nil
  end
  
  it "should render the new action" do
    get :new, :event_id => Factory(:event)
    
    response.should be_success
    response.should render_template(:new)
    assigns[:commentable].should_not be_nil
    assigns[:comment].should_not be_nil
  end
  
  context "create action" do
    it "should render the new action when invalid params supplied" do
      lambda {
        post :create, :event_id => Factory(:event), :comment => {}
      }.should_not change(Comment, :count)
      
      response.should be_success
      response.should render_template(:new)
      assigns[:commentable].should_not be_nil
      assigns[:comment].should_not be_nil
      assigns[:comment].should_not be_valid
    end
    
    it "should create a new comment when valid params supplied" do
      event = Factory(:event)
      lambda {
        post :create, :event_id => event, :comment => Factory.attributes_for(:comment)
      }.should change(Comment, :count).by(1)
      
      response.should be_redirect
      response.should redirect_to(event_comments_path(event))
      assigns[:commentable].should_not be_nil
      assigns[:comment].should_not be_nil
      flash[:notice].should == "#{Comment.model_name.human.humanize} agregado"
    end
  end
  
  it "should render the show action" do
    get :show, :id => Factory(:comment)
    
    response.should be_success
    response.should render_template(:show)
    assigns[:comment].should_not be_nil
    assigns[:commentable].should_not be_nil
  end
  
  context "edit action" do
    before { @comment = Factory(:comment) }
  
    it "should deny access to anyone who is not the comment's author" do
      get :edit, :id => @comment
      
      response.status.should  == 401
      response.body.should == 'No tiene acceso'
      assigns[:comment].should_not be_nil
      assigns[:commentable].should_not be_nil
    end
    
    it "should deny access to anyone who is not the comment's author" do
      sign_in @comment.author
      get :edit, :id => @comment
      
      response.should  be_success
      response.should render_template(:edit)
      assigns[:comment].should_not be_nil
      assigns[:commentable].should_not be_nil
    end
  end
  
  context "update action" do
    before do 
      @comment = Factory(:comment)
      sign_in @comment.author
    end
    
    it "should render the edit action when invalid params supplied" do
      put :update, :id => @comment, :comment => {:content => ''}
      
      response.should be_success
      response.should render_template(:edit)
      assigns[:comment].should_not be_nil
      assigns[:comment].should_not be_valid
      assigns[:commentable].should_not be_nil
    end
    
    it "should update an existing comment when valid params supplied" do
      put :update, :id => @comment, :comment => {:content => '..'}
      
      response.should be_redirect
      response.should redirect_to(@comment)
      assigns[:comment].should_not be_nil
      assigns[:commentable].should_not be_nil
      flash[:notice].should == "#{Comment.model_name.human.humanize} actualizado"
    end
  end
  
  it "should delete an existing comment" do
    comment = Factory(:comment)
    commentable = comment.commentable
    sign_in comment.author
    lambda {
      delete :destroy, :id => comment
    }.should change(commentable.comments, :count).by(-1)
    
    response.should be_redirect
    response.should redirect_to(event_comments_path(commentable))
    assigns[:comment].should_not be_nil
    assigns[:commentable].should_not be_nil
    flash[:notice].should == "#{Comment.model_name.human.humanize} eliminado"
  end

end
