require 'spec_helper'

describe Comment do

  it "should only save valid instances" do
    event = Factory(:event)
    
    comment = event.comments.build
    comment.should_not be_valid
    comment.should have(1).error_on(:content)
    comment.should have(1).error_on(:author_id)
  end
  
  it "should return a string representation of itself" do
    comment = Factory(:comment, :content => 'some random characters')
    comment.to_s.should == 'Some random characters'
  end

  it "should tell whether it can be updated/deleted by a given user" do
    comment = Factory(:comment)
    comment.should be_updatable_by(comment.author)
    comment.should_not be_updatable_by(Factory(:user))
  end
  
end
