module ApplicationHelper
  def active_navigation?(controllers_name, actions_name = nil)
    if controllers_name.include?(controller_name)
      if actions_name.nil? || actions_name.include?(action_name)
        'active'
      end
    end
  end


  def datetime_zoned(datetime, place)
    datetime.in_time_zone(place.timezone)
  end

  def datetime_zoned_date(datetime, place)
    datetime_zoned(datetime, place).strftime("#{place.date_format}")
  end

  def datetime_zoned_time(datetime, place)
    datetime_zoned(datetime, place).strftime("#{place.time_format}")
  end

  def datetime_zoned_datetime(datetime, place)
    datetime_zoned(datetime, place).strftime("#{place.date_format} #{place.time_format}")
  end

  def unread_messages_count(user, event = nil, sender = nil)
    User::PrivateMessage.unread_messags_for(user.id, event&.id, sender&.id).size
  end

  def bootstrap_class_for_flash(flash_type)
    case flash_type
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    when 'notice'
      'alert-info'
    else
      flash_type.to_s
    end
  end
end
