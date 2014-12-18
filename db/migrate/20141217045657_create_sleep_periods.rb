class CreateSleepPeriods < ActiveRecord::Migration
  def change
    create_table :sleep_periods do |t|
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
