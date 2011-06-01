class VersionsController < ApplicationController
  before_filter :authenticate_user!
  
  def project
    @project = Project.find(params[:id])
  end
end
