require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ProjectsStatusHelper. For example:
#
# describe ProjectsStatusHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ProjectsStatusHelper do
  it "should display an indicator class for a given project" do
    helper.indicator_class_for(Factory(:project, :estimated_end_date => Date.yesterday)).should == 'black'
    helper.indicator_class_for(Factory(:project)).should == 'red'
    helper.indicator_class_for(Factory(:project, :estimated_start_date => Date.tomorrow)).should == 'yellow'
    helper.indicator_class_for(Factory(:project, :started_on => Date.yesterday, 
                                       :status => Project::Status::IN_DEV)).should == 'green'
    helper.indicator_class_for(Factory(:project, :started_on => Date.yesterday, 
                                       :status => Project::Status::FINISHED)).should == 'blue'
  end
  
  it "should return a sortable column link" do
    @column, @direction, title = 'id', 'asc', 'title'
    
    ProjectsStatusHelper.class_eval do
      def sort_column
        @column
      end
      
      def sort_direction
        @direction
      end
    end
    
    link = helper.sortable(@column, title)
    link.should include(title)
    link.should include("sort=#{@column}")
    link.should include('direction=desc')
  end
end
