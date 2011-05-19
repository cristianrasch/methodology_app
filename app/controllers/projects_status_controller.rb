class ProjectsStatusController < ApplicationController
  layout 'widescreen'
  helper_method :sort_column, :sort_direction
  
  before_filter :authenticate_user!
  
  def index
    @project = Project.new(params[:project])
    @projects = Project.search(@project, params.merge(:order => order)).includes(:dev, :events)
  end
  
  private
  
  def order
    sort_column + ' ' + sort_direction
  end
  
  def sort_column
    Project.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
