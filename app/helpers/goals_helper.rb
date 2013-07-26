module GoalsHelper
  #-#grey = future
  #-#checked = checkin

  def checkin_class(checkin_dates, target_date)
    Rails.logger.info checkin_dates.to_yaml
    Rails.logger.info target_date.to_yaml
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