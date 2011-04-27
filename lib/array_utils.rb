module ArrayUtils

  def to_a(obj)
    obj.is_a?(Array) ? obj : Array[obj]
  end

end
