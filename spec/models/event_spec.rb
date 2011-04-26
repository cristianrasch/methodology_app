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

end
