class Holiday < ActiveRecord::Base
  
  include DateUtils
  
  validates :name, :presence => true
  validates :date, :presence => true, :uniqueness => true 
  
  scope :in_year, lambda {|year| where(['year(date) = ?', year]) }
  scope :this_year, in_year(Date.today.year)
  scope :ordered, order(:date)
  
  attr_accessible :name, :date
  date_writer_for :date
  
end
