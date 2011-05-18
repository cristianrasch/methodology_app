class OrgUnitsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_boss_logged_in
  
  def index
    @org_units = OrgUnit.not_leaves.with_children.ordered.page(params[:page]).per(10)
  end
  
  def new
    @org_unit = OrgUnit.new
  end
  
  def create
    @org_unit = OrgUnit.new(params[:org_unit])
    
    if @org_unit.save
      redirect_to(@org_unit, :notice => "#{OrgUnit.model_name.human.humanize} creada")
    else
      render :action => :new
    end
  end
  
  def show
    @org_unit = OrgUnit.find(params[:id], :include => [:parent, :children])
  end
  
  def edit
    @org_unit = OrgUnit.find(params[:id])
  end
  
  def update
    @org_unit = OrgUnit.find(params[:id])
    
    if @org_unit.update_attributes(params[:org_unit])
      redirect_to(@org_unit, :notice => "#{OrgUnit.model_name.human.humanize} actualizada")
    else
      render :action => :edit
    end
  end
  
  def destroy
    OrgUnit.delete(params[:id])
    redirect_to(org_units_path, :notice => "#{OrgUnit.model_name.human.humanize} eliminada")
  end
end
