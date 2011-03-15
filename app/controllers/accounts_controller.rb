class AccountsController < ApplicationController

  before_filter :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    
    if @user.update_attributes(params[:user])
      redirect_to(root_path, :notice => 'Cuenta actualizada')
    else
      render :action => :edit
    end
  end

end
