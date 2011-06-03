class EventsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :grab_project, :only => [:index, :new, :create]
  
  def index
    @events = @project.events.includes(:comments).page(params[:page]).per(10)
  end
  
  def new
    @event = @project.events.build
  end
  
  def create
    @event = @project.events.build(params[:event])
    @event.author = current_user
    
    if @event.save
      redirect_to(@event, :notice => "#{Event.model_name.human.humanize} creado")
    else
      render :action => :new
    end
  end
  
  def show
    @event = Event.find(params[:id], :include => [:project, :author])
  end
  
  def edit
    @event = Event.find(params[:id], :include => :project)
  end
  
  def update
    @event = Event.find(params[:id])
    
    if @event.update_attributes(params[:event])
      redirect_to(@event, :notice => "#{Event.model_name.human.humanize} actualizado")
    else
      render :action => :edit
    end
  end

  def destroy
    @event = Event.find(params[:id], :include => :project)
    @event.destroy
    redirect_to(project_events_path(@event.project), 
                :notice => "#{Event.model_name.human.humanize} eliminado")
  end
  
  private
  
  def grab_project
    @project = Project.find(params[:project_id])
  end

end
