require 'spec_helper'

describe Duration::Utils do
  before do
    Dur = Struct.new(:duration, :duration_unit)
    @dur = Dur.new
    @dur.extend(Duration::Utils)
  end
  
  it "should translate duration into and from seconds" do
    %w{hour day week}.each do |unit|
      @dur.duration, @dur.duration_unit = 100, "Duration::#{unit.upcase}".constantize
      @dur.duration_in_seconds(@dur, :duration).should == 100.send("#{unit}s")
      @dur.duration, @dur.duration_unit = 100.send("#{unit}s"), "Duration::#{unit.upcase}".constantize
      @dur.original_duration(@dur, :duration).should == 100
    end
  end
end