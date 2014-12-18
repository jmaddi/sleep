module ApplicationHelper
  def friendly_duration(duration)
    seconds  = duration % 60
    minutes = ((duration/60) % 60).floor
    hours   = (duration/3600).floor

    message = []

    message.push "1 hour"         if hours == 1
    message.push "#{hours} hours" if hours > 1

    message.push "1 minute"         if minutes == 1
    message.push "#{minutes} minutes" if minutes > 1

    message.join ' '
  end
end
