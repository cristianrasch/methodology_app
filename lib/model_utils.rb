module ModelUtils
  
  def build_model(clazz, attrs)
    model = clazz.new
    attrs.each { |k, v| model.send("#{k}=", v) }
    model
  end  
  
end
