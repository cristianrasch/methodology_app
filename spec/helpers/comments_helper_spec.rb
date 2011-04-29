require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the CommentsHelper. For example:
#
# describe CommentsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe CommentsHelper do

  it "return a new comment link based on the params supplied" do
    helper.new_comment_link(:event_id => 2).should include('events/2/comments/new')
    helper.new_comment_link(:task_id => 2).should include('tasks/2/comments/new')
  end
  
  it "return a comments link based on the params supplied" do
    helper.comments_link(Factory(:event)).should match(/events\/\d+\/comments/)
    helper.comments_link(Factory(:task)).should match(/tasks\/\d+\/comments/)
  end
  
end
