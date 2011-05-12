module ApplicationHelper
  def not_found(model)
    content_tag :p do
      content_tag :em, "No se encontraron #{model.is_a?(Class) ? model.model_name.human.pluralize : model}"
    end 
  end

  def created_at(model)
    content_tag :p do
      content_tag(:em, t('lbls.created_at').html_safe)+
      '<br/>'.html_safe+
      l(model.created_at, :format => :short)
    end
  end
  
  def updated_at(model)
    content_tag :p do
      content_tag(:em, t('lbls.updated_at').html_safe)+
      '<br/>'.html_safe+
      l(model.created_at, :format => :short)
    end if model.updated_at
  end

  def duration_options_for(model, attr)
    select_tag("#{model.class.name.downcase}[#{attr}]", 
              options_for_select([['Horas', Duration::HOUR], ['Dias', Duration::DAY], 
                                ['Semanas', Duration::WEEK]], model.send(attr)))
  end
  
  def duration_desc(model, attr)
    singular = case(model.send("#{attr}_unit"))
      when Duration::HOUR then 'hora'
      when Duration::DAY then 'día'
      when Duration::WEEK then 'semana'
    end
    pluralize(model.send(attr), singular)
  end
  
  def date_default_value(date)
    date ? l(date) : nil
  end
end
