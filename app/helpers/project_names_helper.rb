module ProjectNamesHelper
  def potential_ancestors(project_names)
    project_names.map do |project_name, children|
      html = render('parent', :parent => project_name)
      html += children.empty? ? '' : content_tag(:div, potential_ancestors(children), :class => "nested_project_names")
    end.join('<br/>').html_safe
  end
  
  def nested_project_names(project_names)
    project_names.map do |project_name, children|
      html = render(project_name)
      html += children.empty? ? '' : content_tag(:ul, nested_project_names(children), :class => "nested_project_names")
    end.join.html_safe
  end
  
  def path_for(project_name)
    project_name.path.map do |project_name|
      link_to(project_name.text, project_name)
    end.join("&nbsp;-->&nbsp;").html_safe
  end
end
