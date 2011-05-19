require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ProjectNamesHelper. For example:
#
# describe ProjectNamesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ProjectNamesHelper do
  context "ancestors" do
    before do
      @roots = []
      2.times { @roots << Factory(:project_name) }
      @child = Factory(:project_name, :parent => @roots.first)
      @another_child = Factory(:project_name, :parent => @child)
      @project_name = Factory(:project_name)
    end
    
    it "should display potential ancestors radio buttons" do
      html = helper.potential_ancestors(@project_name.potential_ancestors)
      (@roots.clone << @child).each { |project_name|
        html.should include(project_name.text)
      }
      html.should_not include(@another_child.text)
    end
    
    it "should display nested project names" do
      html = helper.nested_project_names(ProjectName.arranged)
      (@roots.clone << @child << @another_child).each { |project_name|
        html.should include(project_name.text)
      }
    end
    
    it "should display a project's name's path" do
      html = helper.path_for(@another_child)
      html.should include(@roots.first.text)
      html.should include(@child.text)
      html.should include(@another_child.text)
    end
  end
end
