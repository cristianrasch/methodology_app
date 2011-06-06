require 'spec_helper'

describe DocumentsController do
  render_views

  before do 
    @current_user = Factory(:user)
    sign_in @current_user
  end
  
  it "should display a list of event's documents" do
    get :index, :event_id => Factory(:event)
    
    response.should be_success
    response.should render_template(:index)
    assigns[:event].should_not be_nil
    assigns[:documents].should_not be_nil
  end

  it "should display the new Document form" do
    get :new, :event_id => Factory(:event)
    
    response.should be_success
    response.should render_template(:new)
    assigns[:event].should_not be_nil
    assigns[:document].should_not be_nil
    assigns[:document].should be_a_new_record
  end  

  context "create action" do
    before { @event = Factory(:event) }
    
    it "should redisplay the new Document form when invalid params are submitted" do
      lambda {
        post :create, :event_id => @event, :document => {}
      }.should_not change(@event.documents, :count)
      
      response.should be_success
      response.should render_template(:new)
      assigns[:event].should_not be_nil
      assigns[:document].should_not be_nil
      assigns[:document].should be_invalid
    end
    
    it "should create a new Document when valid params are submitted" do
      lambda {
        post :create, :event_id => @event, :document => Factory.attributes_for(:document)
      }.should change(@event.documents, :count).by(1)
      
      response.should be_redirect
      assigns[:document].should_not be_nil
      response.should redirect_to(assigns[:document])
      assigns[:event].should_not be_nil
      flash[:notice].should == "#{Document.model_name.human.humanize} creado"
    end
  end
  
  it "should display Document's page" do
    get :show, :id => Factory(:document)
    
    response.should be_success
    response.should render_template(:show)
    assigns[:document].should_not be_nil
    assigns[:document].should be_valid
  end
  
  it "should display Document's edit form" do
    get :edit, :id => Factory(:document)
    
    response.should be_success
    response.should render_template(:edit)
    assigns[:document].should_not be_nil
  end

  context "update action" do
    before { @document = Factory(:document) }
  
    it "should redisplay Document's edit form when invalid params are submitted" do
      put :update, :id => @document, :document => { :duration => 0 }
      
      response.should be_success
      response.should render_template(:edit)
      assigns[:document].should_not be_nil
      assigns[:document].should_not be_valid
    end
    
    it "should update an existing document when valid params are submitted" do
      put :update, :id => @document, :document => { :duration => 1, :duration_unit => Duration::WEEK }
      
      response.should be_redirect
      response.should redirect_to(@document)
      assigns[:document].should_not be_nil
      flash[:notice].should == "#{Document.model_name.human.humanize} actualizado"
    end
  end
  
  it "should delete an existing Document" do
    document = Factory(:document)
    lambda {
      delete :destroy, :id => document
    }.should change(Document, :count).by(-1)
    
    response.should be_redirect
    response.should redirect_to(event_documents_path(document.event))
    assigns[:document].should_not be_nil
    assigns[:document].should be_destroyed
    flash[:notice].should == "#{Document.model_name.human.humanize} eliminado"
  end
end
