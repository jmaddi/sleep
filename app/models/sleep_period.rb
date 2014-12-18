class SleepPeriod < ActiveRecord::Base
  scope :significant, where("strftime('%s', ends_at)-strftime('%s', starts_at) > 0")
end
