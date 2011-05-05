require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the AccountHelper. For example:
#
# describe AccountHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ApplicationHelper do

  it "should display a not found message" do
    helper.not_found(Comment).should =~ /No se encontraron comentarios/
    str = 'archivos'
    helper.not_found(str).should =~ /No se encontraron #{str}/
  end
  
  it "should display a created_at parag for a given record" do
    link = helper.created_at(Factory(:project))
    link.should include('<p>')
    link.should include(I18n.t('lbls.created_at'))
    link.should include(Date.today.day.to_s)
  end
  
  it "should display an updated_at parag for a given record" do
    project = Factory(:project)
    project.update_attribute(:updated_at, nil)
    helper.updated_at(project).should be_nil
    
    project.touch
    link = helper.updated_at(project)
    link.should include('<p>')
    link.should include(I18n.t('lbls.updated_at'))
    link.should include(Date.today.day.to_s)
  end

end
