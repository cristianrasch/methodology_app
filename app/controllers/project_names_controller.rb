class ProjectNamesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_boss_or_dev_logged_in
  
  def index
    @project_names = ProjectName.arranged
  end
  
  def new
    @project_name = ProjectName.new(:parent_id => params[:parent_id])
    @project_names = @project_name.potential_ancestors unless params[:parent_id]
  end
  
  def create
    @project_name = ProjectName.new(params[:project_name])
    
    if @project_name.save
      redirect_to(@project_name, :notice => "#{ProjectName.model_name.human.humanize} creado")
    else
      @project_names = @project_name.potential_ancestors
      render :action => :new
    end
  end
  
  def show
    @project_name = ProjectName.find(params[:id])
  end
  
  def edit
    @project_name = ProjectName.find(params[:id])
    @project_names = @project_name.potential_ancestors
  end
  
  def update
    @project_name = ProjectName.find(params[:id])
    
    if @project_name.update_attributes(params[:project_name])
      redirect_to(@project_name, :notice => "#{ProjectName.model_name.human.humanize} actualizado")
    else
      @project_names = @project_name.potential_ancestors
      render :action => :edit
    end
  end
  
  def destroy
    ProjectName.destroy(params[:id])
    redirect_to(project_names_path, :notice => "#{ProjectName.model_name.human.humanize} eliminado")
  end
end
