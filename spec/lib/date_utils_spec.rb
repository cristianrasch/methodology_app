require 'spec_helper'

describe DateUtils do

  before do
    @obj = Object.new
    @obj.extend(DateUtils)
  end
  
  it "should return a Date object based on the string passed in" do
    date = @obj.format_date('25/12/2006')
    date.day.should == 25
    date.month.should == 12
    date.year.should == 2006
  end

end
