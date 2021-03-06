class ProjectName < ActiveRecord::Base
  has_ancestry :cache_depth => true
  
  validates :text, :presence => true, :uniqueness => { :scope => :ancestry }
  validate :tree_depth
  
  scope :ordered, order(:text)
  
  attr_accessible :text, :parent_id
  
  before_save :humanize_text
  
  class << self
    def arranged
      before_depth(3).arrange(:order => 'text')
    end
    
    def leaves(project_names)
      project_names.map do |project_name, children|
        children.empty? ? project_name : leaves(children)
      end.flatten.compact
    end
  end
  
  def potential_ancestors
    if new_record?
      ances = self.class.roots
    elsif ancestry_depth < 2
      ances = self.class.before_depth(2).where(:id ^ id)
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
