# coding: utf-8

class Task < ActiveRecord::Base

  include Commentable
  include AsyncEmail
  
  class Status
    NEW = 1
    ACCEPTED = 2
    REJECTED = 3
    IN_PROGRESS = 4
    FINISHED = 5
    
    SELECT = [['Aceptada', ACCEPTED], ['Rechazada', REJECTED], ['En progreso', IN_PROGRESS]]
  end

  belongs_to :project
  belongs_to :author, :class_name => 'User'
  belongs_to :owner, :class_name => 'User'
  belongs_to :updater, :class_name => 'User', :foreign_key => :updated_by
  has_many :comments, :as => :commentable, :dependent => :delete_all
  
  validates :description, :presence => true
  validates :duration, :numericality => { :greater_than => 0, :message => I18n.t('errors.messages.blank'), 
                                          :allow_nil => true }
  validates :author_id, :numericality => true
  validates :owner_id, :numericality => { :greater_than => 0, :message => I18n.t('errors.messages.blank') }
  validates :project_id, :numericality => true
  
  scope :ordered, order(:created_at.desc)
  scope :incomplete, where(:finished_at => nil)
  
  attr_accessible :description, :owner_id, :duration, :updated_by, :status
  1.upto(3) { |i| attr_accessible "attachment#{i}", "attachment#{i}_cache" }
  
  1.upto(3) { |i| mount_uploader "attachment#{i}", FileUploader }
  
  after_save :notify_task_saved
  
  def duration=(dur)
    if dur.present?
      write_attribute(:duration, dur)
      self.status = Status::FINISHED
      self.finished_at = Time.now
    end
  end
  
  def attributes=(attrs)
    if attrs.has_key?(:updated_by) && attrs[:updated_by].to_i != attrs[:owner_id].to_i
      attrs.delete(:duration)
      attrs.delete(:status)
    end
    super
  end
  
  private
  
  def notify_task_saved
    send_async(TaskNotifier, :task_saved, self)
  end
  
end
