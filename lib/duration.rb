module Duration
  HOUR = 1
  DAY = 2
  WEEK = 3
  
  def in_days(obj, attr)
    case(obj.send("#{attr}_unit"))
      when HOUR then (obj.send(attr) > 4 ? 1 : 0)*6
      when DAY then obj.send(attr).to_i
      when WEEK then obj.send(attr)*5
    end
  end
end
