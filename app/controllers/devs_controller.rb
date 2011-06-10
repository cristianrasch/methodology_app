class DevsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_boss_logged_in
  
  def projects
    @dev = User.find(params[:id])
    @on_course_projects = @dev.dev_projects.on_course.order(:started_on)
    @pending_projects = @dev.dev_projects.upcoming.order(:estimated_start_date)
    @today = Date.today
  end
end
