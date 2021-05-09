module RailsPlus::Helpers::SmartDatetime
  def smart_datetime(datetime, without_time: false, with_time: true, force_with_year: false)
    return if datetime.blank?
    template = if datetime > Time.zone.now.midnight && datetime < Time.zone.now.end_of_day
                 '%H:%M'
               elsif force_with_year || \
                     datetime < Time.zone.now.beginning_of_year || \
                     datetime > Time.zone.now.end_of_year
                 without_time ? '%d %b %Y' : '%d %b %Y %H:%M'
               else
                 without_time ? '%d %b' : '%d %b %H:%M'
               end
    l datetime, format: template
  end
end
