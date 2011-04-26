require 'spec_helper'

describe Commentable do

  before do
    @obj = Object.new
    @obj.extend(Commentable)
  end
  
  it "should tell whether it has files attached" do
    1.upto(3) { |i| @obj.stub!("attachment#{i}?").and_return(false) }
    @obj.should_not have_attachments
    1.upto(3) { |i| @obj.stub!("attachment#{i}?").and_return(true) }
    @obj.should have_attachments
  end
  
end
