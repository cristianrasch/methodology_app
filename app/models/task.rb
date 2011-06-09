# coding: utf-8

class Task < ActiveRecord::Base
  
  class Status
    NEW = 1
    ACCEPTED = 2
    REJECTED = 3
    IN_PROGRESS = 4
    FINISHED = 5
    
    SELECT = [['Nueva', NEW], ['Aceptada', ACCEPTED], ['Rechazada', REJECTED], 
              ['En progreso', IN_PROGRESS], ['Finalizada', FINISHED]]
  end
  
  include Commentable
  include AsyncEmail
  include Duration

  belongs_to :project
  belongs_to :author, :class_name => 'User'
  belongs_to :owner, :class_name => 'User'
  belongs_to :updater, :class_name => 'User', :foreign_key => :updated_by
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  validates :description, :presence => true
  validates :duration, :numericality => { :greater_than => 0, :message => I18n.t('errors.messages.blank'), 
                                          :allow_nil => true }
  validates :author_id, :numericality => true
  validates :owner_id, :numericality => { :greater_than => 0, :message => I18n.t('errors.messages.blank') }
  validates :project_id, :numericality => true
  
  scope :ordered, order(:created_at.desc)
  scope :incomplete, where(:finished_at => nil)
  
  after_save :notify_task_saved
  
  1.upto(3) { |i| mount_uploader "attachment#{i}", FileUploader }
  
  attr_accessible :description, :owner_id, :duration, :updated_by, :status, :duration_unit
  1.upto(3) { |i| attr_accessible "attachment#{i}", "attachment#{i}_cache", "remove_attachment#{i}" }
  
  def duration=(dur)
    if dur.present?
      write_attribute(:duration, dur)
      self.status = Status::FINISHED
      self.finished_at = Time.now
    end
  end
  
  def attributes=(attrs)
    if !new_record? && attrs[:updated_by] != (attrs.has_key?(:owner_id) ? attrs[:owner_id].to_i : owner.id)
      attrs.delete(:duration)
      attrs.delete(:duration_unit)
      attrs.delete(:status)
    end
    super
  end
  
  def status_str
    arr = Status::SELECT.find {|arr| arr.last == status}
    arr.first if arr
  end
  
  def duration_in_days
    in_days(self, :duration)
  end
  
  private
  
  def notify_task_saved
    send_async(TaskNotifier, :task_saved, self)
  end
end
