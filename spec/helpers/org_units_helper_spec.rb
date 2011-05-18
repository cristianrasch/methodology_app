require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the OrgUnitsHelper. For example:
#
# describe OrgUnitsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe OrgUnitsHelper do
  it "should return an array of parents for a given OrgUnit" do
    org_unit = Factory(:org_unit)
    helper.parents_for(OrgUnit.new).should have(1).record
    helper.parents_for(org_unit).should be_empty
  end
end
