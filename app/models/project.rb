class Project < ActiveRecord::Base

  include DateUtils

  validates :org_unit, :presence => true
  validates :area, :presence => true
  validates :first_name, :presence => true
  validates :description, :presence => true
  validates :estimated_start_date, :presence => true
  validates :estimated_end_date, :presence => true
  validates :estimated_duration, :numericality => { :greater_than => 0 }
  validates :started_on, :presence => true, :if => Proc.new { |project| project.ended_on }
  validates :ended_on, :presence => true, :if => Proc.new { |project| project.actual_duration }
  validates :actual_duration, :presence => true, :if => Proc.new { |project| project.ended_on }
  validate :estimated_dates
  validate :dates
  
  scope :active, lambda { where(:started_on.gteq => Date.today, :ended_on => nil) }
  
  def name
    last_name ? first_name+' - '+last_name : first_name
  end
  
  %w{estimated_start_date estimated_end_date started_on ended_on}.each do |attr|
    define_method("#{attr}=") do |date|
      if date.is_a?(Date)
        write_attribute(attr, date)
      else
        write_attribute(attr, (date.blank? ? nil : format_date(date)))
      end
    end
  end
  
  private
  
  def estimated_dates
    if estimated_start_date && estimated_end_date && estimated_start_date > estimated_end_date
      errors.add(:estimated_end_date)
    end
  end
  
  def dates
    if started_on && ended_on && started_on > ended_on
      errors.add(:ended_on)
    end
  end

end
