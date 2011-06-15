module ProjectsHelper
  def potential_project_names(project_names)
    project_names.map do |project_name, children|
      children.empty? ? render('project_name', :project_name => project_name) : potential_project_names(children)
    end.join('<br/>').html_safe
  end
  
  def indicator_for(project)
    image_tag("#{project.status_indicator}.png", :border => 0)
  end
end
