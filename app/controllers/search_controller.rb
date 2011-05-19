class SearchController < ApplicationController

  before_filter :authenticate_user!
  
  include ModelUtils
  
  def projects
    @project = build_model(Project, params[:project])
    @projects = Project.search(@project, params)
    render 'projects/index'
  end

end
