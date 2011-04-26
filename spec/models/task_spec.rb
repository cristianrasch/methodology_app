require 'spec_helper'

describe Task do

  it "should only save valid instances" do
    task = Task.new
    task.should_not be_valid
    task.should have(1).error_on(:description)
    task.should have(1).error_on(:author_id)
    task.should have(1).error_on(:owner_id)
  end
  
  it "should be finished after setting its duration" do
    task = Factory.build(:task)
    task.duration = 20
    task.finished_at.should_not be_nil
  end
  
  it "should send emails after being created" do
    lambda {
      Factory(:task)
    }.should change(ActionMailer::Base.deliveries, :length)
  end
  
  it "should send emails after being updated" do
    task = Factory(:task)
    lambda {
      task.update_attribute(:description, 'xxx')
    }.should change(ActionMailer::Base.deliveries, :length)
  end
  
end
