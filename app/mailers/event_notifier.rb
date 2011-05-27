# coding: utf-8

class EventNotifier < ActionMailer::Base
  default :from => Conf.notifications_from

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_notifier.event_saved.subject
  #
  def event_saved(event)
    @event = event
    project = event.project
    recipients = project.dev.email
    # recipients = project.all_users.map(&:email)
    mail(:to => recipients, :subject => "#{event.created_at == event.updated_at ? 'Nuevo' : 'Edición de'} #{Event.model_name.human}")
  end
end
