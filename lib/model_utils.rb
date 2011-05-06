module ModelUtils
  
  def build_model(klass, attrs)
    model = klass.new
    attrs.each { |k, v| model.send("#{k}=", v) }
    model
  end  
  
end
