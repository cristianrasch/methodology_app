class ProjectsController < ApplicationController

  before_filter :authenticate_user!
  
  def index
    @projects = Project.active.page(params[:page]).per(10)
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
    @project = Project.find(params[:id])
  end

  def edit
    @project = Project.find(params[:id])
  end
  
  def update
    @project = Project.find(params[:id])
    
    if @project.update_attributes(params[:project])
      redirect_to @project, :notice => "#{Project.model_name.human.humanize} actualizado"
    else
      render :action => :edit
    end
  end
  
  def destroy
    Project.delete_all(['id = ?', params[:id]])
    redirect_to projects_path, :notice => "#{Project.model_name.human.humanize} eliminado"
  end

end
