class SearchController < ApplicationController

  before_filter :authenticate_user!
  
  def projects
    @project = Project.new(params[:project])
    @projects = Project.search(@project, params[:page])
    render 'projects/index'
  end

end
