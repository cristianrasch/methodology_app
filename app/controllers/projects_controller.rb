class ProjectsController < ApplicationController

  before_filter :authenticate_user!
  
  autocomplete :project, :area, :column_name => 'area', :scopes => :by_area
  
  def index
    @project = Project.new
    @projects = Project.search_for(current_user, params[:page])
  end
  
  def new
    @project = Project.new
  end
  
  def create
    @project = Project.new(params[:project])
    
    if @project.save
      redirect_to @project, :notice => "#{Project.model_name.human.humanize} creado"
    else
      render :action => :new
    end
  end
  
  def show
    @project = Project.find(params[:id], :include => [:dev, :users])
  end

  def edit
    @project = Project.find(params[:id])
  end
  
  def update
    @project = Project.find(params[:id])
    
    if @project.update_attributes(params[:project].merge(:updated_by => current_user.id))
      redirect_to @project, :notice => "#{Project.model_name.human.humanize} actualizado"
    else
      render :action => :edit
    end
  end
  
  def destroy
    Project.destroy(params[:id])
    redirect_to projects_path, :notice => "#{Project.model_name.human.humanize} eliminado"
  end
  
  def library
    @project = Project.find(params[:id], :include => :events)
  end

end
