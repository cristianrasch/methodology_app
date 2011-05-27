# coding: utf-8

class ProjectNotifier < ActionMailer::Base
  default :from => Conf.notifications_from

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.project_notifications.new_project.subject
  #
  def project_saved(project)
    @project = project
    recipients = project.dev.email
    # recipients = project.all_users.map(&:email)
    mail(:to => recipients, :subject => "#{project.created_at == project.updated_at ? 'Nuevo' : 'Edición de'} #{Project.model_name.human}")
  end
end
