require 'spec_helper'

describe Event do

  context "validations" do
    it "should only save valid instances" do
      event = Event.new
      event.should_not be_valid
      event.should have(1).error_on(:stage)
      event.should have(1).error_on(:status)
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
      event.update_attribute(:status, Event::Status::IN_DEV)
    }.should change(ActionMailer::Base.deliveries, :length)
  end

  it "should display its status & stage descriptions" do
    event = Event.new :stage => Event::Stage::DEFINITION, :status => Event::Status::IN_DEV
    event.stage_str.should be_present
    event.status_str.should be_present
  end
  
  it "should return a string representation of itself" do
    event = Factory.build(:event)
    str = event.to_s
    str.should match(/#{event.stage_str}/i)
    str.should match(/#{event.status_str}/i)
  end
  
  it "should calculate its duration in days" do
    event = Factory(:event)
    1.upto(3) { |i| event.documents << Factory(:document, :duration => i) }
    
    event.duration_in_days.should == 6
  end
end
