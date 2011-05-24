class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_boss_logged_in
  
  def index
  end
  
  def new
    @report = Report.new(params[:type])
    @data = @report.graph_data
    
    render :new, :layout => 'widescreen'
  end
end
