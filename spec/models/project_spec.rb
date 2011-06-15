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
       project.should have(1).error_on(:dev_id)
       project.should have(1).error_on(:owner_id)
       project.should have(1).error_on(:project_name_id)
       project.should have(1).error_on(:requirement)
       project.should have(1).error_on(:org_unit_id)
       project.should have(1).error_on(:req_nbr)
     end

     it "should validate dev's & owner's email addresses" do
       user = Factory(:user, :email => nil)
       project = Project.new(:dev => user, :owner => user)
       project.should_not be_valid

       project.should have(1).error_on(:dev_id)
       project.should have(1).error_on(:owner_id)
     end
     
     it "should validate project's owner is not among its users" do
       project = Factory.build(:project)
       project.users << project.owner
       
       project.should be_invalid
       project.should have(1).error_on(:owner_id)
     end
   end

   it "should find active projects" do
     active_project = create_model(:project, :started_on => Date.yesterday, :status => Project::Status::IN_DEV)
     2.times { create_model(:project, :status => Project::Status::FINISHED) }
     projects = Project.on_course
     
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

  it "should search for projects and order them based on the supplied params" do
    p1 = create_model(:project, :project_name_id => Factory(:project_name, :text => '..').id)
    2.times {
      create_model(:project, :project_name => Factory(:project_name, :parent => p1.project_name))
    }
    p2 = create_model(:project, :started_on => 1.week.ago.to_date)
    dev = Factory(:user)
    p3 = Factory(:project, :dev => dev)

    Project.search(Project.new(:project_name_id => p1.project_name_id)).should have(3).records
    pr = Project.new
    pr.started_on = 8.days.ago.to_date
    Project.search(pr, :order => 'created_at desc').should have(1).record
    Project.search(Project.new(:dev_id => dev.id, :indicator => Project::Indicator::COMMITTED)).should have(1).record
  end

  context "search for on course projects" do
    before do
      2.times { Factory(:project, :status => Project::Status::IN_DEV) }
      @dev = find_dev
      @dev_projects = []
      3.times { @dev_projects << Factory(:project, :dev => @dev, :status => Project::Status::IN_DEV) }
    end

    it "should return dev's current projects" do
      projects = Project.search_for(@dev)
      projects.should have(3).record
      projects.first.should == @dev_projects.last
    end
    
    it "should return on course projects sorted by dev" do
      Project.search_for(find_boss).should have(5).records
    end
  end

  it "should know all project's participants" do
    project = Factory(:project)
    3.times { project.users << Factory(:user) }
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
      1.upto(2) do |i| 
        event = Factory(:event, :project => @project)
        Factory(:document, :duration => 5*i, :event => event)
      end
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

  # it "should not mass-assign its compl_perc attr when project's status is either NEW or FINISHED" do
  #   project = Factory(:project)
  #   dev_id = project.dev.id
  #   project.update_attributes(:compl_perc => 10)
  #   project.compl_perc.should == 0
  #   project.update_attributes(:compl_perc => 10, :status => Project::Status::IN_DEV, :updated_by => dev_id)
  #   project.compl_perc.should == 10
  #   project.update_attributes(:compl_perc => 30, :status => Project::Status::FINISHED, :updated_by => dev_id)
  #   project.compl_perc.should == 100
  # end

  it "should return a string representation of its klass" do
    Factory.build(:project).klass_str.should be_present
  end

  it "should be able to tell whether its library is empty or not" do
    project = Factory(:project)
    event = Factory(:event, :project => project)
    project.library_empty?.should be_true
    Factory(:document, :event => event)
    project.reload.library_empty?.should be_false
  end

  it "should not be able to set its status to klass if still NEW" do
    project = Factory(:project)
    project.update_attributes(:status => Project::Status::FINISHED, :updated_by => project.dev.id)
    project.should be_new
  end

  context "when updating a project" do
    # it "should not allow editing certain attrs when it isn't a new project" do
    #   project = Factory(:project)
    #   new_descrip = '...'
    #   project.update_attributes(:description => new_descrip)
    #   project.description.should == new_descrip
    #   project.update_attributes(:description => '..', :status => Project::Status::IN_DEV,
    #                             :updated_by => project.dev.id)
    #   project.description.should == new_descrip
    # end
    
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
  
  it "should count projects by dev" do
    dev1 = Factory(:user)
    stopped_project = Factory(:project, :dev => dev1)
    stopped_project.update_attributes(:status => Project::Status::STOPPED, :updated_by => dev1.id)
    on_course_project = Factory(:project, :dev => dev1)
    on_course_project.update_attributes(:status => Project::Status::IN_DEV, :updated_by => dev1.id)
    Factory(:project, :dev => dev1)
    
    dev2 = Factory(:user)
    canceled_project = Factory(:project, :dev => dev2)
    canceled_project.update_attributes(:status => Project::Status::CANCELED, :updated_by => dev2.id)
    
    hash = Project.by_dev
    hash.should have(1).element
    hash[dev1][:on_course].should have(1).project
    hash[dev1][:pending].should have(1).project
    hash[dev1][:stopped].should have(1).project
  end
  
  it "should only allow modify its notify_envisaged_end_date_changed" do
    Project.new(:notify_envisaged_end_date_changed => '1').notify_envisaged_end_date_changed.should be_false
    project = Factory(:project)
    project.update_attributes(:notify_envisaged_end_date_changed => '1')
    project.notify_envisaged_end_date_changed.should be_false
    project.update_attributes(:envisaged_end_date => 6.months.from_now.to_date, :notify_envisaged_end_date_changed => '1')
    project.notify_envisaged_end_date_changed.should be_true
  end

  it "should set its estimated_end_date attr based on the specified estimated duration" do
    project = Project.new(:estimated_start_date => Date.today, 
                          :estimated_duration => 2, :estimated_duration_unit => Duration::WEEK)
    project.estimated_end_date.should_not be_nil
    project.estimated_end_date.should == 10.business_days.after(Date.today).to_date
  end
  
  # it "should notify project's owner of schedule changes only when told so" do
  #   project = Factory(:project)
    
  #   lambda {
  #     project.update_attribute(:envisaged_end_date, 2.weeks.from_now.to_date)
  #    }.should_not change(ActionMailer::Base.deliveries, :length)
     
  #    lambda {
  #     project.update_attributes(:envisaged_end_date => 2.months.from_now.to_date, :notify_envisaged_end_date_changed => '1')
  #    }.should change(ActionMailer::Base.deliveries, :length).by(1)
     
  #    email = ActionMailer::Base.deliveries.first
  #    email.to.should include(project.dev.email)
  #    email.to.should include(project.owner.email)
  # end
  
  it "should create project's first event once work it's started" do
    project = Factory(:project)
    project.update_attributes(:status => Project::Status::IN_DEV, :updated_by => project.dev_id)
    
    project.should be_in_dev
    project.events(true).should have(1).event
    event = project.events.first
    event.stage.should == Event::Stage::DEFINITION
    event.status.should == Event::Status::IN_DEV
    event.author.should == project.dev
  end
  
  it "should auto stop its latest event when a Project is stopped" do
    project = Factory(:project)
    project.update_attributes(:status => Project::Status::IN_DEV, :updated_by => project.dev_id)
    project.update_attributes(:status => Project::Status::STOPPED, :updated_by => project.dev_id)
    
    project.should be_stopped
    project.events.first.status.should == Event::Status::STOPPED
  end
  
  it "should return an envisaged end date from a given date" do
    project = Factory(:project, :estimated_start_date => Date.today, 
                      :estimated_duration => 1, :estimated_duration_unit => Duration::WEEK)
    a_week_from_now = 1.week.from_now.to_date
    project.envisaged_end_date_from(nil).should == a_week_from_now
    project.envisaged_end_date_from(a_week_from_now).should == 2.weeks.from_now.to_date
  end
  
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
    
    it "should be green for projects starting & ending on the same day" do
      project = Factory(:project, :estimated_start_date => Date.today, 
                        :estimated_end_date => Date.today, 
                        :status => Project::Status::IN_DEV, :started_on => Date.today)
      project.status_indicator.should == :green
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
