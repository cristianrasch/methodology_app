require 'spec_helper'

describe ProjectName do
  it "should require a unique name" do
    name = ProjectName.new
    name.should_not be_valid
    name.should have(1).error_on(:text)
    name.text = Factory(:project_name).text
    name.should_not be_valid
    name.should have(1).error_on(:text)
  end
  
  it "should humanize its text before being saved" do
    name = Factory(:project_name, :text => 'lalala')
    name.should be_persisted
    name.text.should == 'Lalala'
  end
  
  it "should have a unique name per parent" do
    parent = Factory(:project_name)
    child1 = Factory(:project_name, :text => "child1", :parent => parent)
    child2 = Factory.build(:project_name, :text => child1.text, :parent => parent)
    child2.should_not be_valid
    child2.should have(1).error_on(:text)
  end
  
  it "should only allow saving nodes with depth lower or equal to three" do
    parent = Factory(:project_name)
    2.times { |i| parent = Factory(:project_name, :text => i.to_s, :parent => parent) }
    child3 = Factory.build(:project_name, :text => 'third child', :parent => parent)
    child3.should_not be_valid
    child3.should have(1).error_on(:ancestry_depth)
  end
  
  context "ancestors" do
    before do
      @roots = []
      2.times { @roots << Factory(:project_name) }
      @child = Factory(:project_name, :parent => @roots.first)
      @another_child = Factory(:project_name, :parent => @child)
    end
    
    it "should return potential ancestors for a new record" do
      ancestors = ProjectName.new.potential_ancestors
      ancestors.should have(2).records
      ancestors[@roots.first].should have(1).record
    end
    
    it "should return potential ancestors for a persisted record which depth is less than 2" do
      ancestors = @child.potential_ancestors
      ancestors.should have(2).records
      ancestors.values.each {|hash| hash.should be_empty}
      ancestors.keys.should_not include(@child)
    end
    
    it "should return potential ancestors for a persisted record which depth is equal to 2" do
      ancestors = @another_child.potential_ancestors
      ancestors.should have(1).record
      ancestors[@roots.first].should have(1).record
      ancestors[@roots.first].keys.first.should == @child
      ancestors.keys.should_not include(@another_child)
    end
  end
  
  it "should return a list of project's names which depth is lower than 3" do
    roots = []
    2.times { roots << Factory(:project_name) }
    Factory(:project_name, :parent => roots.first)
    project_names = ProjectName.arranged
    project_names.should have(2).records
    project_names[roots.first].should have(1).record
  end
  
  it "should return an Array of leaves" do
    roots = []
    2.times { roots << Factory(:project_name) }
    child = Factory(:project_name, :parent => roots.first)
    another_child = Factory(:project_name, :parent => child)
    
    leaves = ProjectName.leaves(ProjectName.arranged)
    leaves.should include(roots.last)
    leaves.should include(another_child)
    leaves.should_not include(roots.first)
    leaves.should_not include(child)
  end
end
