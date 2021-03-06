today = Date.today
at_beginning_of_month = today.at_beginning_of_month

xml.chart(:dateFormat => "dd/mm/yyyy", :hoverCapBorderColor => "2222ff", :hoverCapBgColor => "e1f5ff", :ganttWidthPercent => "94", :ganttLineAlpha => "80", :canvasBorderColor => "024455", :canvasBorderThickness => "0", :gridBorderColor => "4567aa", :gridBorderAlpha => "20") do
  
  xml.categories(:bgColor => "ffffff", :fontColor => "1288dd", :fontSize => "10") do
    13.times do |i|
      date = today.advance(:months => i)
      xml.category(:start => l(date.at_beginning_of_month), :end => l(date.at_end_of_month), :align => "center", :name => "#{t('date.abbr_month_names')[date.month]} #{date.strftime('%y')}", :isBold => "1")
    end
  end
  
  xml.processes(:headerText => dev.username, :fontColor => "ffffff", :fontSize => "10", :isBold => "1", :isAnimated => "1", :bgColor => "4567aa", :headerVAlign => "right", :headerbgColor => "4567aa", :headerFontColor => "ffffff", :headerFontSize => "16", :width => "80", :align => "left") do
    [on_course_projects, pending_projects].each do |projects|
      projects.each { |project|
        xml.process(:Name => "##{project.req_nbr}", :id => project.id)
      }
    end
  end
  
  i, start_date = 0, nil
  xml.tasks(:width => "10") do
    on_course_projects.each do |project|
      start_date = project.started_on && project.started_on > at_beginning_of_month ? project.started_on : at_beginning_of_month
      
      xml.task(:name => replace_accented_chars(project.requirement), :processId => project.id, :start => l(start_date), :end => l(project.envisaged_end_date), :id => project.req_nbr, :color => "4567aa", :height => "10", :topPadding => i-i*0.5, :animation => "0", :link => url_for(project))
      i += 1
    end
    
    unless pending_projects.empty?
      prev_envisaged_end_date = nil
      envisaged_end_date = pending_projects.first.envisaged_end_date_from(on_course_projects.empty? ? (pending_projects.first.estimated_start_date < at_beginning_of_month ? at_beginning_of_month : nil) : on_course_projects.last.envisaged_end_date)
      
      pending_projects.each_with_index do |project, j|
        # needs to be calculated based on our next project, but not on the first iteration
        envisaged_end_date = project.envisaged_end_date_from(envisaged_end_date) unless j.zero?
        
        start_date = prev_envisaged_end_date.nil? ?  (on_course_projects.empty? ? at_beginning_of_month : on_course_projects.last.envisaged_end_date) : prev_envisaged_end_date
      
        xml.task(:name => replace_accented_chars(project.requirement), :processId => project.id, :start => l(start_date), :end => l(envisaged_end_date), :id => project.req_nbr, :color => "4567aa", :height => "10", :topPadding => i-i*0.8, :animation => "0", :link => url_for(project))
        
        prev_envisaged_end_date = envisaged_end_date
        i += 1
      end
    end
  end
end
