class Document < ActiveRecord::Base
  include Duration

  validates :file, :presence => true
  validates :duration, :numericality => { :greater_than => 0, :message => I18n.t('errors.messages.blank'), 
                                          :allow_nil => true }
  validates :event_id, :numericality => true
  
  belongs_to :event
  
  mount_uploader :file, FileUploader
  
  before_save :humanize_comment
  
  attr_accessible :file, :file_cache, :duration, :duration_unit, :comment
  
  def name
    comment.present? ? comment : File.basename(file.to_s)
  end
  
  def duration_in_days
    in_days(self, :duration)
  end
  
  private
  
  def humanize_comment
    self.comment = comment.humanize if comment.present?
  end
end
