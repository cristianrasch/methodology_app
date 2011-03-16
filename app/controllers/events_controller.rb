class EventsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :grab_project
  
  def index
    @events = @project.events.ordered.page(params[:page]).per(10)
  end
  
  def new
    @event = @project.events.build
  end
  
  def create
    @event = @project.events.build(params[:event])
    @event.author = current_user
    
    if @event.save
      redirect_to([@project, @event], :notice => "#{Event.model_name.human.humanize} creado")
    else
      render :action => :new
    end
  end
  
  def show
    @event = @project.events.find(params[:id], :include => :author)
  end
  
  def edit
    @event = @project.events.find(params[:id])
  end

  def destroy
    @event = @project.events.find(params[:id])
    @event.destroy
    redirect_to(project_events_path(@project), 
                                    :notice => "#{Event.model_name.human.humanize} eliminado")
  end
  
  private
  
  def grab_project
    @project = Project.find(params[:project_id])
  end

end
