require 'spec_helper'

describe Project do

  it "should only save valid instances" do
    project = Project.new
    project.should_not be_valid
    
    project.should have(1).error_on(:org_unit)
    project.should have(1).error_on(:area)
    project.should have(1).error_on(:first_name)
    project.should have(1).error_on(:description)
    project.should have(1).error_on(:estimated_start_date)
    project.should have(1).error_on(:estimated_end_date)
    project.should have(1).error_on(:estimated_duration)
    project.should have(1).error_on(:user_ids)
  end
  
  it "should find active projects" do
    active_project = Factory(:project, :started_on => Date.today)
    2.times { 
      Factory(:project, :started_on => 4.days.ago.to_date, :ended_on => Date.yesterday, :actual_duration => 20) 
    }
    
    projects = Project.active.all
    projects.should have(1).record
    projects.first.should == active_project
  end
  
  context "project dates" do
    it "should validates its estimated dates" do
      project = Factory.build(:project, :estimated_start_date => Date.today, :estimated_end_date => Date.yesterday)
      project.should_not be_valid
      project.should have(1).error_on(:estimated_end_date)
    end
    
    it "should validates its dates" do
      project = Factory.build(:project, :started_on => Date.today, :ended_on => Date.yesterday, :actual_duration => 20)
      project.should_not be_valid
      project.should have(1).error_on(:ended_on)
    end
    
    it "should require the ended_on date if actual_duration is specified" do
      project = Factory.build(:project, :actual_duration => 25)
      project.should_not be_valid
      project.should have(1).error_on(:ended_on)
    end
  end
  
  it "should require started_on & actual_duration when ended_on supplied" do
    project = Factory.build(:project, :ended_on => Date.today)
    project.should_not be_valid
    project.should have(1).error_on(:started_on)
    project.should have(1).error_on(:actual_duration)
  end
  
  it "should display its name correctly" do
    project = Factory.build(:project)
    project.to_s.should == project.first_name
    project.last_name = 'secret'
    project.to_s.should include('-')
  end
  
  it "should write its dates based on the strings supplieded as params" do
    project = Project.new
    
    %w{estimated_start_date estimated_end_date started_on ended_on}.each do |attr|
      project.send("#{attr}=", nil)
      project.send(attr).should be_nil
      project.send("#{attr}=", "")
      project.send(attr).should be_nil
      project.send("#{attr}=", "22/12/2005")
      date = project.send(attr)
      date.day.should == 22
      date.month.should == 12
      date.year.should == 2005
    end
  end

  it "should delete its events & tasks once deleted" do
    project = Factory(:project)
    3.times { Factory(:event, :project => project) }
    2.times { Factory(:task, :project => project) }
    
    # 3.times { project.events.create!(Factory.attributes_for(:event, :author => user)) }
    project.destroy
    project.events(true).should be_empty
    project.tasks(true).should be_empty
  end
end
