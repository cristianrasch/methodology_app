module ProjectsStatusHelper
  def indicator_class_for(project)
    return 'black' if project.estimated_end_date < Date.today && project.ended_on.nil?
    return 'red' if project.estimated_start_date < Date.today && project.new?
    return 'yellow' if project.estimated_start_date > Date.today
    return 'green' if project.started_on <= Date.today && project.ended_on.nil?
    return 'blue' if project.finished?
  end
end
