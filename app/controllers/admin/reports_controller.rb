class Admin::ReportsController < ApplicationController
  before_filter :basic_authenticate
  
  def index
  end
  
  def new
    @type = params[:type].to_i
    @report = Report.new(@type)
    @data = @report.graph_data
    
    render :action => :new, :layout => 'widescreen'
  end
end
