class ProjectsStatusController < ApplicationController
  layout 'widescreen'
  
  before_filter :authenticate_user!
  
  def index
    @project = Project.new(params[:project])
    @projects = Project.search(@project, params[:page]).includes(:dev, :events)
  end
end
