# coding: utf-8

class Notifications < ActionMailer::Base
  default :from => Conf.notifications_from

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.has_not_signed_in_since_last_week.subject
  #
  def has_not_signed_in_since_last_week(user)
    @user = user

    mail(:to => user.email, :subject => "#{user.username.upcase}: no se ha logueado en la última semana!")
  end
end
