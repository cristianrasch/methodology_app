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
  
  it "should send emails after being created" do
    lambda {
      Factory(:comment)
    }.should change(ActionMailer::Base.deliveries, :length)
  end
  
  it "should send emails after being updated" do
    comment = Factory(:comment)
    lambda {
      comment.update_attribute(:content, 'xxx')
    }.should change(ActionMailer::Base.deliveries, :length)
  end
  
  it "should automatically include its author & owner as part of its users" do
    author, owner = Factory(:user), Factory(:user)
    task = Factory(:task, :author => author, :owner => owner)
    comment = Factory(:comment, :commentable => task, :author => Factory(:user))
    comment.users.should include(author)
    comment.users.should include(owner)
  end
  
end
