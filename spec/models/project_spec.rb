# coding: utf-8

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
    
    project.destroy
    project.events(true).should be_empty
    project.tasks(true).should be_empty
  end
  
  it "should send emails after being created" do
    lambda {
      Factory(:project)
    }.should change(ActionMailer::Base.deliveries, :length)
  end
  
  it "should send emails after being updated" do
    project = Factory(:project)
    lambda {
      project.update_attribute(:estimated_end_date, 3.months.from_now.to_date)
    }.should change(ActionMailer::Base.deliveries, :length)
  end
  
  it "should list its tasks depending on the params supplied" do
    project = Factory(:project)
    2.times { Factory(:task, :project => project) }
    3.times { Factory(:task, :project => project, :duration => 4) }
    project.tasks.list.should have(2).records
    project.tasks.list(:show_all => true).should have(5).records
  end
  
  it "should search for projects based on the supplied params" do
    p1 = Factory(:project, :org_unit => 'matriculas')
    p2 = Factory(:project, :first_name => 'certificado de inscripción, libre deuda y sanción en la matric')
    p3 = Factory(:project, :started_on => 1.week.ago.to_date)
    dev = Factory(:user)
    p4 = Factory(:project, :dev => dev)
    
    Project.search(Project.new(:org_unit => 'matriculas')).should have(1).record
    Project.search(Project.new(:first_name => 'inscripción')).should have(1).record
    Project.search(Project.new(:started_on => 2.weeks.ago.to_date)).should have(1).record
    Project.search(Project.new(:dev => dev)).should have(1).record
  end
  
  context "search for active projects" do
    before do
      2.times { Factory(:project) }
      @dev = find_dev
      3.times { Factory(:project, :dev => @dev) }
    end
  
    it "should return dev's current projects" do
      Project.search_for(@dev).should have_at_most(3).records
    end
  
    it "should return the latest projects for a non-dev user" do
      Project.search_for(Factory(:user)).should have_at_least(5).records
    end
  end
  
  it "should know all project's participants" do
    project = Factory(:project)
    users = project.all_users
    
    users.should have(5).records
    users.should include(project.dev)
    users.should include(project.owner)
  end
  
  it "should only allow its dev to change its status" do
    project = Factory(:project)
    project.update_attributes(:status => Project::Status::IN_DEV)
    project.status.should == Project::Status::NEW
    project.update_attributes(:status => Project::Status::IN_DEV, :updated_by => project.dev.id)
    project.status.should == Project::Status::IN_DEV
  end
  
  it "should return a string representation of its status" do
    Factory.build(:project).status_str.should be_present
  end
  
  it "should calculate its actual duration once closed" do
    project = Factory(:project)
    2.times { |i| Factory(:event, :duration => 5*(i+1), :project => project) }
    2.times { |i| Factory(:task, :duration => 3*(i+1), :project => project) }
    project.actual_duration.should be_nil
    project.update_attributes(:status => Project::Status::FINISHED, :updated_by => project.dev.id)
    project.reload
    project.actual_duration.should_not be_nil
    project.actual_duration.should == 24
  end
  
end
