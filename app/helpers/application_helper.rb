module ApplicationHelper
  
  def not_found(model)
    content_tag :p do
      content_tag :em, "No se encontraron #{model.is_a?(Class) ? model.model_name.human.pluralize : model}"
    end 
  end

  def created_at(model)
    content_tag :p do
      t('lbls.created_at').html_safe+'<br/>'.html_safe+
      l(model.created_at, :format => :short)
    end
  end
  
  def updated_at(model)
    content_tag :p do
      t('lbls.updated_at').html_safe+'<br/>'.html_safe+
      l(model.created_at, :format => :short)
    end if model.updated_at
  end

end
