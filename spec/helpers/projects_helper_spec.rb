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

end
