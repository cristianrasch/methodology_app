class TasksController < ApplicationController

  before_filter :authenticate_user!
  before_filter :grab_project, :only => [:index, :new, :create]
  
  def index
    @tasks = @project.tasks.incomplete.ordered.page(params[:page]).per(10)
  end
  
  def new
    @task = @project.tasks.build
  end
  
  def create
    @task = @project.tasks.build(params[:task])
    @task.author = current_user
    
    if @task.save
      redirect_to(@task, :notice => "#{Task.model_name.human.humanize} creada")
    else
      render :action => :new
    end
  end
  
  def show
    @task = Task.find(params[:id], :include => [:author, :owner])
  end
  
  def edit
    @task = Task.find(params[:id], :include => :project)
  end
  
  def update
    @task = Task.find(params[:id])
    
    if @task.update_attributes(params[:task])
      redirect_to(@task, :notice => "#{Task.model_name.human.humanize} actualizada")
    else
      render :action => :edit
    end
  end

  def destroy
    @task = Task.find(params[:id], :include => :project)
    @task.destroy
    redirect_to(project_tasks_path(@task.project), 
               :notice => "#{Task.model_name.human.humanize} eliminada")
  end
  
  private
  
  def grab_project
    @project = Project.find(params[:project_id])
  end

end
