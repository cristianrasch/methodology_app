class Comment < ActiveRecord::Base

  include AsyncEmail

  mount_uploader :attachment, FileUploader

  belongs_to :commentable, :polymorphic => true
  belongs_to :author, :class_name => 'User'
  has_and_belongs_to_many :users

  validates :content, :presence => true
  validates :commentable_id, :numericality => true
  validates :commentable_type, :presence => true
  validates :author_id, :numericality => true
  
  scope :ordered, order(:created_at.desc)
  
  after_save :notify_comment_saved
  
  def to_s
    content.to_s.humanize
  end

  def updatable_by?(user)  
    author == user
  end
  
  private
  
  def notify_comment_saved
    send_async(CommentNotifier, :comment_saved, self)
  end
  
end
