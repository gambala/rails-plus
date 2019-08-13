module DatetimeHelper
  def smart_datetime(datetime, without_time: false, with_time: true)
    return if datetime.blank?
    template = if datetime > Time.zone.now.midnight && datetime < Time.zone.now.end_of_day
                 '%H:%M'
               elsif datetime > Time.zone.now.beginning_of_year
                 without_time ? '%d %b' : '%d %b %H:%M'
               else
                 without_time ? '%d %b %Y' : '%d %b %Y %H:%M'
               end
    l datetime, format: template
  end
end
