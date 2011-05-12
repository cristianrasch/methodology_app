module Duration
  HOUR = 1
  DAY = 2
  WEEK = 3
  
  def in_days(obj, attr)
    case(obj.send("#{attr}_unit"))
      when Duration::HOUR then obj.send(attr) > 4 ? 1 : 0
      when Duration::DAY then obj.send(attr)
      when Duration::WEEK then obj.send(attr)*5
    end
  end
end
