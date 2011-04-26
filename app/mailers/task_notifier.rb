# coding: utf-8

class TaskNotifier < ActionMailer::Base
  default :from => Conf.notifications_from

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.task_notifier.task_saved.subject
  #
  def task_saved(task)
    @task = task
    recipients = [task.author.email, task.owner.email, task.project.dev.email]
    mail(:to => recipients, :subject => "#{task.created_at == task.updated_at ? 'Nueva' : 'Edición de'} #{Task.model_name.human}")
  end
end
