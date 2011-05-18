require 'spec_helper'

describe OrgUnitsController do
  render_views
  
  before { sign_in(find_boss) }
  
  it "should deny access to non-boss users" do
    sign_in(Factory(:user))
    get :index
    
    response.status.should == 401
    response.body.should == 'Acceso denegado.'
  end
  
  it "should display a list of OrgUnits" do
    get :index
    
    response.should be_success
    response.should render_template('index')
    assigns[:org_units].should_not be_nil
  end

  it "should display the new OrgUnit form" do
    get :new
    
    response.should be_success
    response.should render_template('new')
    assigns[:org_unit].should_not be_nil
  end  
  
  context "create action" do
    it "should redisplay the new OrgUnit form when invalid params supplied" do
      lambda {
        post :create, :org_unit => {}
      }.should_not change(OrgUnit, :count)
      
      response.should be_success
      response.should render_template('new')
      assigns[:org_unit].should_not be_nil
      assigns[:org_unit].should_not be_valid
    end
    
    it "should create a new OrgUnit when valid params supplied" do
      lambda {
        post :create, :org_unit => Factory.attributes_for(:org_unit)
      }.should change(OrgUnit, :count).by(1)
      
      response.should be_redirect
      assigns[:org_unit].should_not be_nil
      response.should redirect_to(assigns[:org_unit])
      flash[:notice].should == "#{OrgUnit.model_name.human.humanize} creada"
    end
  end
  
  %w{show edit}.each do |action|
    it "should render the #{action} action" do
      get action, :id => Factory(:org_unit)
      
      response.should be_success
      response.should render_template(action)
      assigns[:org_unit].should_not be_nil
      assigns[:org_unit].should be_valid
    end
  end
  
  def update
    @org_unit = OrgUnit.find(params[:id])
    
    if @org_unit.update_attributes(params[:org_unit])
      redirect_to(@org_unit, :notice => "#{OrgUnit.model_name.human.humanize} actualizada")
    else
      render :action => :edit
    end
  end
  
  context "update action" do
    it "should redisplay OrgUnit's edit form when invalid params supplied" do
      put :update, :id => Factory(:org_unit), :org_unit => {:text => ''}
      
      response.should be_success
      response.should render_template('edit')
      assigns[:org_unit].should_not be_nil
      assigns[:org_unit].should_not be_valid
    end
    
    it "should update an OrgUnit when the valid params supplied" do
      put :update, :id => Factory(:org_unit), :org_unit => {:text => '..'}
      
      response.should be_redirect
      assigns[:org_unit].should_not be_nil
      response.should redirect_to(assigns[:org_unit])
      flash[:notice].should == "#{OrgUnit.model_name.human.humanize} actualizada"
    end
  end
  
  it "should delete an OrgUnit" do
    lambda {
      delete :destroy, :id => Factory(:org_unit)
    }.should_not change(OrgUnit, :count)
    
    response.should be_redirect
    response.should redirect_to(org_units_path)
    flash[:notice].should == "#{OrgUnit.model_name.human.humanize} eliminada"
  end
end
