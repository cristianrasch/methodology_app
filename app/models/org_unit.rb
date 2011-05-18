class OrgUnit < ActiveRecord::Base
  validates :text, :presence => true, :uniqueness => { :scope => :parent_id }
  validates :parent_id, :numericality => true, :allow_nil => true
  
  belongs_to :parent, :class_name => self.name
  has_many :children, :class_name => self.name, :foreign_key => :parent_id
  
  scope :not_leaves, where(:parent_id => nil)
  scope :excluding, lambda {|org_unit| where(:id ^ org_unit) }
  scope :ordered, order(:text)
  scope :with_children, includes(:children)
  scope :not_roots, where('not exists (select 1 from org_units ou where ou.parent_id = org_units.id)')
  scope :with_parent, includes(:parent)
  
  attr_accessible :text, :parent_id
  
  def has_children?
    ! children.empty?
  end
  
  def to_s
    parent ? "#{parent.text} -> #{text}" : text
  end
end
