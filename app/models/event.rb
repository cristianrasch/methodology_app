class Event < ActiveRecord::Base

  1.upto(3) { |i| mount_uploader "attachment#{i}", FileUploader }

  belongs_to :project
  belongs_to :author, :class_name => 'User'

  validates :stage, :numericality => { :greater_than => 0, :message => I18n.t('errors.messages.blank') }
  validates :status, :numericality => { :greater_than => 0, :message => I18n.t('errors.messages.blank') }
  validates :duration, :numericality => true
  validates :project_id, :numericality => true
  validates :author_id, :numericality => true
  
  scope :ordered, order(:created_at.desc)

  def to_s
    Event.human_attribute_name(:stage)+': '+Conf.stages[stage].humanize+' - '+Event.human_attribute_name(:status)+': '+Conf.statuses[status].humanize
  end

end
