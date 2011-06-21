class LibrariesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_boss_logged_in

  def index
    @projects = Project.library
  end
end
