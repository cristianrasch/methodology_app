class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_boss_or_dev_logged_in, :except => :index
  
  def index
    if request.xml_http_request?
      @users = User.where("name like ?", "%#{params[:q]}%")
    else
      return unless ensure_boss_or_dev_logged_in
      @users = User.ordered
    end
    
    respond_to do |format|
      format.html
      format.json { render :json => @users.map(&:attributes) }
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.username = params[:username]
    
    if @user.save
      redirect_to(@user, :notice => "#{User.model_name.human.humanize} creado")
    else
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => "#{User.model_name.human.humanize} actualizado")
    else
      render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    
    if @user.delete
      redirect_to(users_path, :notice => "#{User.model_name.human.humanize} eliminado")
    else
      flash.now[:alert] = 'No es posible eliminar desarrolladores'
      render :show
    end
  end
end
