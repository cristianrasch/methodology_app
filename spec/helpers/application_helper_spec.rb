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
  before { I18n.locale = 'es-AR' }
  
  it "should localize dates or return nil" do
    helper.date_default_value(nil).should be_nil
    helper.date_default_value(Date.civil(2008, 12, 23)).should == '23/12/2008'
  end

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
  
  def duration_desc(model, attr)
    singular = case(model.send("#{attr}_unit"))
      when Duration::HOUR then 'hora'
      when Duration::DAY then 'día'
      when Duration::WEEK then 'semana'
    end
    pluralize(model.send("orig_#{attr}"), singular)
  end
  
  it "should display model's duration description" do
    project = Factory(:project, :estimated_duration => 168, :estimated_duration_unit => Duration::HOUR)
    helper.duration_desc(project, :estimated_duration).should == '168 H'
    project.estimated_duration_unit = Duration::DAY
    helper.duration_desc(project, :estimated_duration).should == '168 D'
    project.estimated_duration_unit = Duration::WEEK
    helper.duration_desc(project, :estimated_duration).should == '168 S'
  end
end
