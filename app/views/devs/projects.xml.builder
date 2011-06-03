xml.chart(:dateFormat => "dd/mm/yyyy", :hoverCapBorderColor => "2222ff", :hoverCapBgColor => "e1f5ff", :ganttWidthPercent => "94", :ganttLineAlpha => "80", :canvasBorderColor => "024455", :canvasBorderThickness => "0", :gridBorderColor => "4567aa", :gridBorderAlpha => "20") do
  
  xml.categories(:bgColor => "ffffff", :fontColor => "1288dd", :fontSize => "10") do
    start_date = @projects.first.estimated_start_date
    13.times do |i|
      date = start_date.advance(:months => i)
      xml.category(:start => l(date.at_beginning_of_month), :end => l(date.at_end_of_month), :align => "center", :name => "#{t('date.abbr_month_names')[date.month]} #{date.strftime('%y')}", :isBold => "1")
    end
  end
  
  xml.processes(:headerText => @dev.username, :fontColor => "ffffff", :fontSize => "10", :isBold => "1", :isAnimated => "1", :bgColor => "4567aa", :headerVAlign => "right", :headerbgColor => "4567aa", :headerFontColor => "ffffff", :headerFontSize => "16", :width => "80", :align => "left") do
    @projects.each do |project|
      xml.process(:Name => "##{project.req_nbr}", :id => project.id)
    end
  end
  
#  xml.dataTable(:showProcessName => "1", :nameAlign => "left", :fontColor => "000000", :fontSize => "10", :isBold => "1", :headerBgColor => "00ffff", :headerFontColor => "4567aa", :headerFontSize => "11", :vAlign => "right", :align => "left") do
#    xml.dataColumn(:width => "70", :headerfontcolor => "ffffff", :headerBgColor => "4567aa", :bgColor => "eeeeee", :headerColor => "ffffff", :headerText => 'Desde', :isBold => "0") do
#      @projects.each { |project| xml.text(:label => l(project.estimated_start_date, :format => :graph)) }
#    end
#    xml.dataColumn(:width => "70", :headerfontcolor => "ffffff", :bgColor => "eeeeee", :headerbgColor => "4567aa", :fontColor => "000000", :headerText => 'Hasta', :isBold => "0") do
#      @projects.each { |project| xml.text(:label => l(project.envisaged_end_date, :format => :graph)) }
#    end
#  end

  xml.tasks(:width => "10") do
    @projects.each_with_index do |project, i|
      xml.task(:name => project.requirement, :processId => project.req_nbr, :start => l(project.estimated_start_date), :end => l(project.envisaged_end_date), :id => project.id, :color => "4567aa", :height => "10", :topPadding => "#{i*24}", :animation => "0", :link => url_for(project))
    end
  end
end
