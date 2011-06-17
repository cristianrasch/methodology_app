# coding: utf-8

require 'spec_helper'

describe Project do
  context "status indicator" do
    before {
      @project = Factory(:project, :estimated_start_date => 1.week.ago.to_date, 
                        :estimated_end_date => 1.week.from_now.to_date, 
                        :status => Project::Status::IN_DEV, :started_on => 1.week.ago.to_date)
      @project.reload
    }
  
    it "should be green when everything is running smoothly" do
      @project.update_attributes(:compl_perc => 55, :updated_by => @project.dev.id)
      @project.status_indicator.should == :green
    end
    
    it "should be yellow when things are not going so well" do
      @project.update_attributes(:compl_perc => 45, :updated_by => @project.dev.id)
      @project.status_indicator.should == :yellow
    end
    
    it "should be red when things are awful" do
      @project.update_attributes(:compl_perc => 30, :updated_by => @project.dev.id)
      @project.status_indicator.should == :red
    end
    
    it "should be red for projects starting & ending on the same day" do
      project = Factory(:project, :estimated_start_date => Date.today, 
                        :estimated_end_date => Date.today, 
                        :status => Project::Status::IN_DEV, :started_on => Date.today)
      project.status_indicator.should == :red
    end
  end
  
  it "should touch its compl_perc_updated_at attr before being created" do
    project = Factory(:project)
    project.last_compl_perc_update_at.should_not be_nil
    project.last_compl_perc_update_at.to_date.should == Date.today
    project.last_compl_perc_update_at.hour.should == Time.now.hour
    project.last_compl_perc_update_at.min.should == Time.now.min
  end
  
  it "should notify devs whose projects' compl_perc hasn't been updated in a week" do
    crr = find_dev('crr')
    2.times do
      pr = Factory(:project, :status => Project::Status::IN_DEV, :started_on => 1.week.ago.to_date, :dev => crr)
      pr.update_attribute(:last_compl_perc_update_at, 2.weeks.ago)
    end
    gbe = find_dev('gbe')
    pr = Factory(:project, :status => Project::Status::IN_DEV, :started_on => 1.week.ago.to_date, :dev => gbe)
    pr.update_attribute(:last_compl_perc_update_at, 2.weeks.ago)
    pr.update_attributes(:compl_perc => 25, :updated_by => gbe.id)
    
    lambda {
      Project.notify_devs_compl_perc_has_not_been_updated_since_last_week
    }.should change(ActionMailer::Base.deliveries, :length).by(1)
    ActionMailer::Base.deliveries.last.to.should include(crr.email)
  end
end
