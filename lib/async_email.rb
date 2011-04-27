module AsyncEmail

  def send_async(notifier, method, *params)
    if Rails.env == 'test'
      notifier.send(method, *params).deliver
    else
      notifier.delay.send(method, *params)
    end
  end

end
