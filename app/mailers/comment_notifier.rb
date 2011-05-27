# coding: utf-8

class CommentNotifier < ActionMailer::Base
  default :from => Conf.notifications_from

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.comment_notifier.comment_created.subject
  #
  def comment_saved(comment)
    @comment = comment
    recipients = [comment.commentable.project.dev.email]
    # recipients = comment.users.map(&:email) << comment.commentable.project.dev.email
    mail(:to => recipients.uniq, :subject => "#{comment.created_at == comment.updated_at ? 'Nuevo' : 'Edición de'} #{Comment.model_name.human}")
  end
end
