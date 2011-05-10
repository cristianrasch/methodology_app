class ProjectName < ActiveRecord::Base
  
  validates :text, :presence => true, :uniqueness => { :scope => :ancestry }
  validate :tree_depth
  
  before_save :humanize_text
  
  has_ancestry :cache_depth => true
  
  attr_accessible :text, :parent_id
  
  class << self
    def arranged
      before_depth(3).arrange(:order => 'text')
    end
  end
  
  def potential_ancestors
    if new_record? or ancestry_depth < 2
      ances = self.class.before_depth(2)
      ances = ances.where(:id ^ id) if persisted? and ancestry_depth < 2
    else
      ances = ancestors
    end
    ances.arrange(:order => 'text')
  end
  
  def to_s
    path.map(&:text).join(' --> ')
  end
  
  private
  
  def humanize_text
    self.text = text.humanize
  end
  
  def tree_depth
    errors.add(:ancestry_depth, I18n.t('errors.messages.less_than_or_equal_to').gsub('%{count}', '3')) if depth > 2
  end
end
