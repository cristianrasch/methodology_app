require 'spec_helper'

describe OrgUnit do
  context "model validations" do
    it "should only save valid instances" do
      org_unit = OrgUnit.new
      
      org_unit.should be_invalid
      org_unit.should have(1).error_on(:text)
      org_unit.text = Factory(:org_unit).text
      org_unit.should be_invalid
      org_unit.should have(1).error_on(:text)
    end
  end
  
  context "model scopes" do
    it "should return all non child instances" do
      Factory(:org_unit, :parent => Factory(:org_unit))
      OrgUnit.not_leaves.should have(1).record
    end
    
    it "should return all instances but the one passed in as a param" do
      OrgUnit.excluding(Factory(:org_unit)).should be_empty
    end
  end
  
  it "should downcase its text attr before being saved" do
    Factory(:org_unit, :text => 'sISTEMAS').text.should == 'Sistemas'
  end
  
  it "should be able to tell whether it has children or not" do
    parent = Factory(:org_unit)
    parent.should_not have_children
    Factory(:org_unit, :parent => parent)
    parent.reload.should have_children
  end
end
