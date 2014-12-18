class PagesController < ApplicationController
  def index
    #@sleep_periods = SleepPeriod.order('starts_at DESC').significant
    @sleep_periods = SleepPeriod.order('starts_at DESC').where("strftime('%s', ends_at)-strftime('%s', starts_at) > 120")

    last_period = SleepPeriod.order('starts_at DESC').first
    if last_period.ends_at.nil?
      @current_state = {
        title: 'Asleep',
        duration: Time.now-last_period.starts_at
      }
    else
      @current_state = {
        title: 'Awake',
        duration: Time.now-last_period.ends_at
      }
    end
  end
end
