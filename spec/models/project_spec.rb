# coding: utf-8

require 'spec_helper'

describe Project do

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

end
