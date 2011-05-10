require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ProjectsHelper. For example:
#
# describe ProjectsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ProjectsHelper do
  it "should localize dates or return nil" do
    helper.project_date(nil).should be_nil
    helper.project_date(Date.civil(2008, 12, 23)).should == '23/12/2008'
  end
  
  context "project's project name" do
    before do
      @project = Project.new
      @root = Factory(:project_name, :text => 'root')
      @child1 = Factory(:project_name, :text => 'child1', :parent => @root)
      @child2 = Factory(:project_name, :text => 'child2', :parent => @child1)
    end
    
    it "should display potential project names" do
      child3 = Factory(:project_name, :text => 'child3', :parent => @root)
      html = helper.potential_project_names(ProjectName.arranged)
      
      html.should_not include("project_project_name_id_#{@root.id}")
      html.should_not include("project_project_name_id_#{@child1.id}")
      html.should include("project_project_name_id_#{@child2.id}")
      html.should include("project_project_name_id_#{child3.id}")
    end
    
    it "should display a ProjectName's path" do
      html = helper.path_for(@child2)
      html.should include(@root.text)
      html.should include(@child1.text)
      html.should include(@child2.text)
    end
  end
end
