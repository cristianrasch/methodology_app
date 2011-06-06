require 'spec_helper'

describe Document do
  it "should only save valid instances" do
    doc = Document.new
    
    doc.should be_invalid
    doc.should have(1).error_on(:file)
    doc.should have(1).error_on(:event_id)
  end
  
  it "should return its name" do
    doc = Factory.build(:document)
    doc.name.should == doc.comment
    doc = Factory.build(:document, :comment => nil)
    doc.name.should == 'robots.txt'
  end
end
