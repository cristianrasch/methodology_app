class CommentsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_commentable, :only => [:index, :new, :create]
  before_filter :authenticate_owner!, :only => [:edit, :update, :destroy]

  def index
    @comments = @commentable.comments.ordered.page(params[:page]).per(10)
  end
  
  def new
    @comment = @commentable.comments.build
  end
  
  def create
    @comment = @commentable.comments.build(params[:comment])
    @comment.author = current_user
    
    if @comment.save
      flash[:notice] = "#{Comment.model_name.human.humanize} agregado"
      redirect_to(:controller => :comments, :action => :index, 
                  "#{@commentable.class.name.downcase}_id" => @commentable)
    else
      render :action => :new
    end
  end
  
  def show
    @comment = Comment.find(params[:id], :include => [:author, {:commentable => :project}])
    @commentable = @comment.commentable
    instance_variable_set("@#{@commentable.class.name.downcase}".to_sym, @commentable)
    @project = @commentable.project
  end
  
  def edit
    instance_variable_set("@#{@commentable.class.name.downcase}".to_sym, @commentable)
    @project = @commentable.project
  end
  
  def update
    if @comment.update_attributes(params[:comment])
      redirect_to(@comment, :notice => "#{Comment.model_name.human.humanize} actualizado")
    else
      render :action => :edit
    end
  end
  
  def destroy
    @comment.destroy
    flash[:notice] = "#{Comment.model_name.human.humanize} eliminado"
    redirect_to(:controller => :comments, :action => :index, 
                "#{@commentable.class.name.downcase}_id" => @commentable)
  end
  
  private

  def find_commentable
    value = params.find {|k,v| k.to_s =~ /(.+)_id$/}
    if value
      @commentable = $1.classify.constantize.find(value.last, :include => [:project => :users])
      instance_variable_set("@#{$1}".to_sym, @commentable)
      @project = @commentable.project
    end
  end
  
  def authenticate_owner!
    @comment = Comment.find(params[:id], :include => [:author, {:commentable => {:project => :users}}])
    @commentable = @comment.commentable
    unless @comment.updatable_by?(current_user)
      render(:text => 'Acceso denegado.', :status => :unauthorized) and return false
    end
  end

end
