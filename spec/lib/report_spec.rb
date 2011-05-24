require 'spec_helper'

describe Report do
  it "should report on workload by dev" do
    pap = find_dev('pap')
    crr = find_dev('crr')
    gbe = find_dev('gbe')
    [pap, crr, gbe].each_with_index do |dev, i|
      1.upto(3) { |j| Factory(:project, :dev => dev, :estimated_start_date => j.months.from_now.to_date, 
                              :estimated_duration => (i+1)*j, :estimated_duration_unit => j) }
      
    end
    
    data = Report.new(Report::Type::WORKLOAD_BY_DEV).graph_data
    data.should have(3).items
    [pap, crr, gbe].each {|dev| data[dev].should == 3}
  end
end
