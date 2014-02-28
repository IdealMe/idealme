module ShipDateHelper
  def next_delivery_date(from = nil)
    from = from || Date.current

    dates = []
    4.times do |i|
      dates << from + (i + 1).days
    end
    dates.reject { |date| date.saturday? || date.sunday? }[1]
  end

  def next_delivery_date_month
    next_delivery_date.strftime('%B').upcase
  end

  def next_delivery_date_day
    next_delivery_date.day
  end
end
