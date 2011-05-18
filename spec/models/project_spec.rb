# coding: utf-8

require 'spec_helper'

describe Project do
  context "new instances' validations" do
    it "should only save valid instances" do
      project = Project.new
      project.should_not be_valid
  
      project.should have(1).error_on(:estimated_start_date)
      project.should have(1).error_on(:estimated_end_date)
      project.should have(1).error_on(:estimated_duration)
      project.should have(1).error_on(:user_ids)
      project.should have(1).error_on(:dev_id)
      project.should have(1).error_on(:owner_id)
      project.should have(1).error_on(:project_name_id)
      project.should have(1).error_on(:requirement)
      project.should have(1).error_on(:org_unit_id)
    end
    
    it "should validate dev's & owner's email addresses" do
      user = Factory(:user, :email => nil)
      project = Project.new(:dev => user, :owner => user)
      project.should_not be_valid
  
      project.should have(1).error_on(:dev_id)
      project.should have(1).error_on(:owner_id)
    end
  end

  it "should find active projects" do
    active_project = Factory(:project, :started_on => Date.today)
    2.times {
      create_model(:project, :started_on => 4.days.ago.to_date, :ended_on => Date.yesterday,
                   :actual_duration => 20)
    }

    projects = Project.on_course.all
    projects.should have(1).record
    projects.first.should == active_project
  end

  it "should validates its estimated dates" do
    project = Factory.build(:project, :estimated_start_date => Date.today, :estimated_end_date => Date.yesterday)
    project.should_not be_valid
    project.should have(1).error_on(:estimated_end_date)
  end

  it "should write its dates based on the strings supplieded as params" do
    project = Project.new

    %w{estimated_start_date estimated_end_date}.each do |attr|
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
    p1 = create_model(:project, :project_name_id => Factory(:project_name, :text => '..').id)
    p2 = create_model(:project, :started_on => 1.week.ago.to_date)
    dev = Factory(:user)
    p3 = Factory(:project, :dev => dev)
    p4 = create_model(:project, :status => Project::Status::CANCELED)

    Project.search(Project.new(:project_name_id => p1.project_name_id)).should have(1).record
    pr = Project.new
    pr.started_on = 8.days.ago.to_date
    Project.search(pr).should have(1).record
    Project.search(Project.new(:dev_id => dev.id)).should have(1).record
  end

  context "search for active projects" do
    before do
      2.times { Factory(:project, :status => Project::Status::IN_DEV) }
      @dev = find_dev
      3.times { Factory(:project, :dev => @dev, :status => Project::Status::IN_DEV) }
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

  context "once a project is finished" do
    before do
      @project = Factory(:project, :status => Project::Status::IN_DEV)
      1.upto(2) { |i| Factory(:event, :duration => 5*i, :project => @project) }
      1.upto(2) { |i| Factory(:task, :duration => 3*i, :project => @project) }
      @project.update_attributes(:status => Project::Status::FINISHED, :updated_by => @project.dev.id)
    end

    it "should set its compl_perc to 100" do
      @project.compl_perc.should == 100
    end

    it "should set its ended_on date to today" do
      @project.ended_on.should == Date.today
    end

    it "should calculate its actual duration once closed" do
      @project.actual_duration.should_not be_nil
      @project.actual_duration.should == 24
    end
  end

  it "should auto-start a project when its status is set to in development" do
    project = Factory(:project, :started_on => nil)
    project.update_attributes(:status => Project::Status::IN_DEV, :updated_by => project.dev.id)
    project.started_on.should == Date.today
  end

  it "should be able to set its users" do
    project = Factory(:project)
    users = []
    2.times { users << Factory(:user) }
    project.users.should_not include(users.first)
    project.users.should_not include(users.last)
    project.user_tokens = users.map(&:id).join(',')
    project.users(true).should include(users.first)
    project.users.should include(users.last)
  end

  it "should not mass-assign its compl_perc attr when project's status is either NEW or FINISHED" do
    project = Factory(:project)
    dev_id = project.dev.id
    project.update_attributes(:compl_perc => 10)
    project.compl_perc.should == 0
    project.update_attributes(:compl_perc => 10, :status => Project::Status::IN_DEV, :updated_by => dev_id)
    project.compl_perc.should == 10
    project.update_attributes(:compl_perc => 30, :status => Project::Status::FINISHED, :updated_by => dev_id)
    project.compl_perc.should == 100
  end

  it "should return a string representation of its klass" do
    Factory.build(:project).klass_str.should be_present
  end

  it "should be able to tell whether its library is empty or not" do
    project = Factory(:project)
    project.library_empty?.should be_true
    event = Factory(:event, :attachment1 => File.open(File.join(Rails.root, 'README')), :project => project)
    project.events.reload
    project.library_empty?.should be_false
  end

  it "should not be able to set its status to klass if still NEW" do
    project = Factory(:project)
    project.update_attributes(:status => Project::Status::FINISHED, :updated_by => project.dev.id)
    project.should be_new
  end

  context "when updating a project" do
    it "should not allow editing certain attrs when it isn't a new project" do
      project = Factory(:project)
      new_descrip = '...'
      project.update_attributes(:description => new_descrip)
      project.description.should == new_descrip
      project.update_attributes(:description => '..', :status => Project::Status::IN_DEV,
                                :updated_by => project.dev.id)
      project.description.should == new_descrip
    end
    
    it "should still allow editing certain attrs when it isn't a new project" do
      project = Factory(:project)
      project.update_attributes(:compl_perc => 35, :status => Project::Status::STOPPED,
                                :envisaged_end_date => 2.weeks.from_now.to_date,
                                :updated_by => project.dev.id)
      project.compl_perc.should == 35
      project.should be_stopped
      project.envisaged_end_date.should == 2.weeks.from_now.to_date
    end
  end
  
  it "should validate project's envisaged_end_date when set" do
    pr = Factory.build(:project, :started_on => Date.today, :envisaged_end_date => Date.yesterday)
    pr.should_not be_valid
    pr.should have(1).error_on(:envisaged_end_date)
  end
  
  it "should set a default envisaged_end_date when none set" do
    project = Factory(:project)
    project.envisaged_end_date.should_not be_nil
    project.envisaged_end_date.should == project.estimated_end_date
  end
  
  it "should auto-update project's schedule when new ones override work priorities" do
    project = Factory(:project, :estimated_start_date => 1.week.from_now.to_date, 
                      :estimated_end_date => 1.month.from_now.to_date, :dev => find_dev)
    pr = Factory(:project, :estimated_start_date => 2.weeks.from_now.to_date, 
                 :estimated_end_date => 1.month.from_now.to_date, :dev => find_dev,
                 :estimated_duration => 1, :estimated_duration_unit => Duration::WEEK)
    
    project.reload
    project.envisaged_end_date.should == 5.business_days.after(1.month.from_now).to_date
    project.delayed_by_proj.should == pr
  end
  
  it "should auto-update project's schedule when delayed_by_proj's envisaged_end_date is changed" do
    a_year_ago = 1.year.ago.to_date
    project = Factory(:project, :estimated_start_date => a_year_ago, 
                      :estimated_end_date => a_year_ago+2.months, :dev => find_dev)
                      
    pr = Factory(:project, :estimated_start_date => a_year_ago+1.week, 
                 :estimated_end_date => a_year_ago+2.weeks, :dev => find_dev,
                 :estimated_duration => 1, :estimated_duration_unit => Duration::WEEK)
    pr.update_attribute(:envisaged_end_date, a_year_ago+3.weeks)
    project.reload
    
    project.envisaged_end_date.should == 10.business_days.after(a_year_ago+2.months).to_date
    
    pr.update_attribute(:envisaged_end_date, a_year_ago+2.weeks)
    project.reload
    
    project.envisaged_end_date.should == 5.business_days.after(a_year_ago+2.months).to_date
  end
end
