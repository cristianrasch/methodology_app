module DateUtils

  def format_date(date)
    Date.civil(*date.split('/').map(&:to_i).reverse)
  end

end
