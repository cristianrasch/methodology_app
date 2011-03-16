module EventsHelper
  
  def stage_select_options
    Conf.stages.to_a.map {|arr| [arr.last.humanize, arr.first]}.
         sort {|arr1, arr2| arr1.last <=> arr2.last}
  end
  
  def status_select_options
    Conf.statuses.to_a.map {|arr| [arr.last.humanize, arr.first]}.
         sort {|arr1, arr2| arr1.last <=> arr2.last}
  end
  
  def event_name(event)
    Event.human_attribute_name(:stage)+': '+
      Conf.stages[event.stage].humanize+' - '+
      Event.human_attribute_name(:status)+': '+
      Conf.statuses[event.status].humanize
  end
  
end
