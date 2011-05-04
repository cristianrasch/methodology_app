require 'spec_helper'

describe UsersController do

  def index
    @users = User.where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @users.map(&:attributes) }
    end
  end
  
  it "should return a list of users matching the given name" do
    Factory(:user, :name => 'Mr. Bean')
    get :index, :format => :json, :q => 'mr'
    
    response.should be_success
    assigns[:users].should_not be_nil
    assigns[:users].should have(1).user
  end

end
