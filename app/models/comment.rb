class Comment < ActiveRecord::Base

  mount_uploader :attachment, FileUploader

  belongs_to :commentable, :polymorphic => true
  belongs_to :author, :class_name => 'User'
  has_and_belongs_to_many :users

  validates :content, :presence => true
  validates :commentable_id, :numericality => true
  validates :commentable_type, :presence => true
  validates :author_id, :numericality => true
  
  scope :ordered, order(:created_at.desc)
  
  after_save :send_after_save_notifications
  
  def to_s
    content.to_s.humanize
  end

  def updatable_by?(user)  
    author == user
  end
  
  private
  
  def send_after_save_notifications
    if Rails.env == 'test'
      CommentNotifier.comment_saved(self).deliver
    else
      CommentNotifier.delay.comment_saved(self)
    end
  end
  
end
