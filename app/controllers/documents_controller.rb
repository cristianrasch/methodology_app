class DocumentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :grab_event, :only => [:index, :new, :create]
  
  def index
    @documents = @event.documents
  end
  
  def new
    @document = @event.documents.build
  end
  
  def create
    @document = @event.documents.build(params[:document])
    
    if @document.save
      redirect_to(@document, :notice => "#{Document.model_name.human.humanize} creado")
    else
      render :new
    end
  end
  
  def show
    @document = Document.find(params[:id], :include => [:event => :project])
    @event, @project = @document.event, @document.event.project
  end
  
  def edit
    @document = Document.find(params[:id], :include => [:event => :project])
    @event, @project = @document.event, @document.event.project
  end
  
  def update
    @document = Document.find(params[:id], :include => :event)
    
    if @document.update_attributes(params[:document])
      redirect_to(@document, :notice => "#{Document.model_name.human.humanize} actualizado")
    else
      render :edit
    end
  end
  
  def destroy
    @document = Document.find(params[:id], :include => :event)
    @document.destroy
    redirect_to(event_documents_path(@document.event), :notice => "#{Document.model_name.human.humanize} eliminado")
  end
  
  private
  
  def grab_event
    @event = Event.find(params[:event_id], :include => :project)
    @project = @event.project
  end
end
