require 'spec_helper'

describe Holiday do
  it "should return an array of this year's holidays" do
    1.upto(2) { |i| Factory(:holiday, :date => i.days.from_now.to_date) }
    1.upto(2) { |i| Factory(:holiday, :date => i.years.ago.to_date) }
    Holiday.this_year.should have(2).holidays
  end
  
  it "should only save valid instances" do
    holiday = Holiday.new
    holiday.should be_invalid
    holiday.should have(1).error_on(:name)
    holiday.should have(1).error_on(:date)
    Factory(:holiday)
    holiday.name = '..'
    holiday.date = Date.tomorrow
    holiday.should be_invalid
    holiday.should have(1).error_on(:date)
  end
end
