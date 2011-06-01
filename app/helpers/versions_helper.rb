module VersionsHelper
  def delay_responsible(project)
    if project.delayed_by
      project = Project.find(project.delayed_by)
      link_to(project.to_s, project)
    else
      User.find(project.versions.last.whodunnit).name
    end
  end
end
