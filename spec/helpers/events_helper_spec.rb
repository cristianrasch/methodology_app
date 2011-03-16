require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the EventsHelper. For example:
#
# describe EventsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe EventsHelper do
  
  %w{stage status}.each do |method|
    it "should return some #{method} select options" do
      matrix = helper.send("#{method}_select_options") 
      matrix.should be_an(Array)
      matrix.should_not be_empty
      arr = matrix.first
      arr.should_not be_empty
    end
  end
  
end
