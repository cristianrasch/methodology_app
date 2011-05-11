require 'spec_helper'

describe DateUtils do

  before do
    Klass = Class.new do
      include DateUtils
      attr_reader :date
      date_writer_for :date      
    end
    @obj = Klass.new
  end
  
  it "should return a Date object based on the string passed in" do
    date = @obj.format_date('25/12/2006')
    date.day.should == 25
    date.month.should == 12
    date.year.should == 2006
  end

end
