require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the VersionsHelper. For example:
#
# describe VersionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe VersionsHelper do
  it "should report whodunnit" do
    project = Factory(:project)
    project.versions.last.update_attribute(:whodunnit, project.dev.id.to_s)
    helper.whodunnit(project.versions.last).should == project.dev.name
  end
end
