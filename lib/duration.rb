module Duration
  HOUR = 1
  DAY = 2
  WEEK = 3
  
  module Utils
    def original_duration(model, attr)
      duration = model.send(attr)
      unit = model.send("#{attr}_unit")
      
      if duration
        dur = duration/(60*60)
        dur /= 24 if unit > HOUR
        dur /= 7 if unit > DAY
        dur.to_i
      end
    end
    
    def duration_in_seconds(model, attr)
      duration = model.send(attr)
      unit = model.send("#{attr}_unit")
      
      case(unit)
        when HOUR then duration.hours
        when DAY then duration.days
        when WEEK then duration.weeks
      end
    end
  end
end