class DevsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_boss_logged_in
  
  def projects
    @dev = User.find(params[:id])
    @projects = @dev.dev_projects.on_course_or_pending.order(:envisaged_end_date)
  end
end
