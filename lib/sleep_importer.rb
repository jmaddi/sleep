class SleepImporter
  STATE_AWAKE    = 0.freeze
  STATE_SLEEPING = 1.freeze

  def import(time, state)
    last_period = SleepPeriod.order('starts_at DESC').first
    if last_period.nil?
      SleepPeriod.create(starts_at: time, ends_at: time) if state == STATE_SLEEPING
    else
      # Awake but previously sleeping
      last_period.update_attributes!(ends_at: time)     if state == STATE_AWAKE && last_period.ends_at.nil?
      # Sleeping but previously awake
      SleepPeriod.create(starts_at: time, ends_at: nil) if state == STATE_SLEEPING && !last_period.ends_at.nil?
    end
        
  end
end
