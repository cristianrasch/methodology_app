module CommentsHelper

  def new_comment_link(params)
    options = {:controller => :comments, :action => :new}
    value = params.find {|k,v| k.to_s =~ /(.+)_id$/}
    options[value.first] = value.last
    link_to 'Nuevo', url_for(options)
  end
  
  def comments_link
    options = {:controller => :comments}
    options["#{@commentable.class.name.downcase}_id".to_sym] = @commentable.id
    # value = params.find {|k,v| k.to_s =~ /(.+)_id$/}
    # options[value.first] = value.last
    link_to 'Comentarios', url_for(options)
  end
  
  def link_to_commentable
    link_to @commentable.class.model_name.human.humanize, @commentable
  end

end
