class DevsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_boss_logged_in
  
  def projects
    @dev = User.find(params[:id])
    @projects = @dev.dev_projects.committed.order(:estimated_start_date)
  end
end
