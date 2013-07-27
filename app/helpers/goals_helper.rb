module GoalsHelper
  def checkin_class(checkin_dates, target_date)
    if checkin_dates.include?(target_date)
      'checked'
    else
      if target_date > DateTime.now.beginning_of_day.strftime('%Y%m%d')
        'grey'
      else
      end
    end
  end
end