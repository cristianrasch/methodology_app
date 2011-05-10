module ProjectsHelper
  def project_date(date)
    date ? l(date) : nil
  end
  
  def potential_project_names(project_names)
    project_names.map do |project_name, children|
      children.empty? ? render('project_name', :project_name => project_name) : potential_project_names(children)
    end.join('<br/>').html_safe
  end
end
