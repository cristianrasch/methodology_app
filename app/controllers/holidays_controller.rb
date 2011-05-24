class HolidaysController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_boss_logged_in
  
  def index
    @holidays = Holiday.this_year.ordered
  end
  
  def new
    @holiday = Holiday.new
  end
  
  def create
    @holiday = Holiday.new(params[:holiday])
    
    if @holiday.save
      redirect_to(holidays_path, :notice => "#{Holiday.model_name.human.humanize} creado")
    else
      render :action => :new
    end
  end
  
  def edit
    @holiday = Holiday.find(params[:id])
  end
  
  def update
    @holiday = Holiday.find(params[:id])
    
    if @holiday.update_attributes(params[:holiday])
      redirect_to(holidays_path, :notice => "#{Holiday.model_name.human.humanize} actualizado")
    else
      render :action => :edit
    end
  end
  
  def destroy
    Holiday.delete(params[:id])
    redirect_to(holidays_path, :notice => "#{Holiday.model_name.human.humanize} eliminado")
  end
end
