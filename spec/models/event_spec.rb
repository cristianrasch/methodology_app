require 'spec_helper'

describe Event do

  context "validations" do
    it "should only save valid instances" do
      event = Event.new
      event.should_not be_valid
      event.should have(1).error_on(:stage)
      event.should have(1).error_on(:status)
      event.should have(1).error_on(:duration)
      event.should have(1).error_on(:project_id)
      event.should have(1).error_on(:author_id)
    end
  end
  
  it "should send emails after being created" do
    lambda {
      Factory(:event)
    }.should change(ActionMailer::Base.deliveries, :length)
  end
  
  it "should send emails after being updated" do
    event = Factory(:event)
    lambda {
      event.update_attribute(:duration, 5)
    }.should change(ActionMailer::Base.deliveries, :length)
  end

  it "should display its status & stage descriptions" do
    event = Event.new :stage => Conf.stages.first.first, :status => Conf.statuses.first.first
    event.stage_str.should be_present
    event.status_str.should be_present
  end
  
  it "should return a string representation of itself" do
    str = Factory.build(:event).to_s
    str.should match(/#{Conf.stages.first.last}/i)
    str.should match(/#{Conf.statuses.first.last}/i)
  end
  
  it "should be able to translate its duration back & forth" do
    event = Factory(:event, :duration => 10, :duration_unit => Duration::HOUR)
    event.duration.should == 10.hours
    event.orig_duration == 10
    event.update_attributes(:duration => 2, :duration_unit => Duration::DAY)
    event.duration.should == 2.days
    event.orig_duration == 2
  end
end
