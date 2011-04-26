module CommentsHelper

  def new_comment_link(params)
    options = {:controller => :comments, :action => :new}
    value = params.find {|k,v| k.to_s =~ /(.+)_id$/}
    options[value.first] = value.last
    link_to 'Nuevo', url_for(options)
  end
  
  def comments_link(params)
    options = {:controller => :comments}
    value = params.find {|k,v| k.to_s =~ /(.+)_id$/}
    options[value.first] = value.last
    link_to 'Inicio', url_for(options)
  end

end
