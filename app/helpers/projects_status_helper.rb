module ProjectsStatusHelper
  def indicator_class_for(project)
    return 'black' if project.estimated_end_date < Date.today && project.ended_on.nil?
    return 'red' if project.estimated_start_date < Date.today && project.new?
    return 'yellow' if project.estimated_start_date > Date.today
    return 'green' if project.started_on <= Date.today && project.ended_on.nil?
    return 'blue' if project.finished?
  end
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, projects_status_index_path(params.merge({:sort => column, :direction => direction})), 
                   {:class => css_class}
  end
end
