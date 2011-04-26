class ProjectNotifier < ActionMailer::Base
  default :from => "desarrollo@consejo.org.ar"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.project_notifications.new_project.subject
  #
  def project_created(project)
    @project = project
    recipients = project.users.map(&:email)
    recipients << project.dev.email
    mail(:to => recipients, :subject => "Nuevo #{Project.model_name.human} - #{project}")
  end
end
