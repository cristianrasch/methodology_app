class Event < ActiveRecord::Base

  include Commentable
  include AsyncEmail

  belongs_to :project
  belongs_to :author, :class_name => 'User'
  has_many :comments, :as => :commentable, :dependent => :delete_all

  validates :stage, :numericality => { :greater_than => 0, :message => I18n.t('errors.messages.blank') }
  validates :status, :numericality => { :greater_than => 0, :message => I18n.t('errors.messages.blank') }
  validates :duration, :numericality => { :greater_than => 0, :message => I18n.t('errors.messages.blank') }
  validates :project_id, :numericality => true
  validates :author_id, :numericality => true
  
  scope :ordered, order(:created_at.desc)
  
  1.upto(3) { |i| mount_uploader "attachment#{i}", FileUploader }
  
  after_save :notify_event_saved

  attr_accessible :stage, :status, :duration, :duration_unit
  1.upto(3) { |i| attr_accessible "attachment#{i}", "attachment#{i}_cache" }

  def to_s
    Event.human_attribute_name(:stage)+': '+
    Conf.stages[stage].humanize+' - '+
    Event.human_attribute_name(:status)+': '+
    Conf.statuses[status].humanize
  end
  
  def stage_str
    Conf.stages[stage].humanize
  end

  def status_str
    Conf.statuses[status].humanize
  end
  
  private
  
  def notify_event_saved
    send_async(EventNotifier, :event_saved, self)
  end
end
