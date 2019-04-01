module DatetimeHelper
  def smart_datetime(datetime, with_time: false)
    return if datetime.blank?
    template = if datetime > Time.zone.now.midnight && datetime < Time.zone.now.end_of_day
                 '%H:%M'
               elsif datetime > Time.zone.now.beginning_of_year
                 with_time ? '%d %b %H:%M' : '%d %b'
               else
                 with_time ? '%d %b %Y %H:%M' : '%d %b %Y'
               end
    l datetime, format: template
  end
end
