class Admin::UsersController < ApplicationController

  before_filter :basic_authenticate
  
  def import
    User.import
    render :text => 'done.'
  end

end
