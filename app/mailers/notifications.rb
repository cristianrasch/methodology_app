# coding: utf-8

class Notifications < ActionMailer::Base
  default :from => Conf.notifications_from

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.has_not_signed_in_since_last_week.subject
  #
  def has_not_signed_in_since_last_week(dev)
    @dev = dev

    mail(:to => dev.email, :subject => "#{dev.username.upcase}: no se ha logueado en la última semana!")
  end
  
  def compl_perc_has_not_been_updated_since_last_week(dev, projects)
    @dev, @projects = dev, projects
    
    mail(:to => dev.email, :subject => "#{dev.username.upcase}: no ha actualizado el estado de sus #{Project.model_name.human.pluralize}!")
  end
end
