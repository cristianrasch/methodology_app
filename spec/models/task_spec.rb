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
  
  it "should only set its status if no duration is provided" do
    task = Factory.build(:task, :status => Task::Status::ACCEPTED)
    task.status.should == Task::Status::ACCEPTED
    task = Factory.build(:task, :status => Task::Status::ACCEPTED, :duration => 120)
    task.status.should == Task::Status::FINISHED
  end
  
  it "should only allow its owner set its duration & status" do
    task = Factory(:task)
    owner = task.owner
    updater = Factory(:user)
    task.update_attributes(:status => Task::Status::ACCEPTED, :duration => 120, :updated_by => updater.id)
    task.status.should == Task::Status::NEW
    task.duration.should be_nil
    task.updater.should == updater
    task.update_attributes(:status => Task::Status::ACCEPTED, :duration => 120, :updated_by => owner.id)
    task.status.should == Task::Status::ACCEPTED
    task.duration.should_not be_nil
    task.updater(true).should == owner
  end
  
  it "should provide a description its status" do
    Factory.build(:task).status_str.should be_present
  end
  
end
