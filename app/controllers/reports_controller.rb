class ReportsController < ApplicationController
  layout 'widescreen', :only => :new
  
  before_filter :authenticate_user!
  before_filter :ensure_boss_logged_in
  
  def index
  end
  
  def new
    @report = Report.new(params[:type])
    @data = @report.graph_data
  end
end
