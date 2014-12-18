require_relative './rails_helper'
require_relative '../lib/sleep_importer'

describe 'SleepImporter' do
  it '#import should create new SleepPeriod' do
    importer = SleepImporter.new
    importer.import(Time.now, SleepImporter::STATE_SLEEPING)

    expect(SleepPeriod.count).to be 1
  end

  it '#import should create new SleepPeriod starting and ending on specified time' do
    importer = SleepImporter.new
    time = Time.now
    importer.import(time, SleepImporter::STATE_SLEEPING)

    period = SleepPeriod.first
    expect(period.starts_at).to eq time
    expect(period.ends_at).to eq time
  end

  it '#import should not create new SleepPeriod if I am awake' do
    importer = SleepImporter.new
    importer.import(Time.now, SleepImporter::STATE_AWAKE)

    expect(SleepPeriod.count).to be SleepImporter::STATE_AWAKE
  end

  it '#import should update ends_at for current period' do
    importer = SleepImporter.new
    start_time = 1.hour.ago
    end_time   = Time.now

    SleepPeriod.create!(starts_at: start_time, ends_at: nil)
    importer.import(end_time, SleepImporter::STATE_AWAKE)

    period = SleepPeriod.first
    expect(period.starts_at).to eq start_time
    expect(period.ends_at).to   eq end_time
  end

  it '#import should not update ends_at for current period' do
    importer = SleepImporter.new
    start_time = 1.hour.ago
    end_time   = Time.now

    SleepPeriod.create!(starts_at: start_time, ends_at: nil)
    importer.import(end_time, SleepImporter::STATE_SLEEPING)

    period = SleepPeriod.first
    expect(period.starts_at).to eq start_time
    expect(period.ends_at).to   eq nil

  end

  it '#import should create new period when sleeping state' do
    importer = SleepImporter.new
    start_time = Time.now

    SleepPeriod.create!(starts_at: 1.hour.ago, ends_at: 30.minutes.ago)
    importer.import(start_time, SleepImporter::STATE_SLEEPING)

    period = SleepPeriod.order('starts_at DESC').first

    expect(SleepPeriod.count).to eq 2

    expect(period.starts_at).to  eq start_time
    expect(period.ends_at).to    eq nil
  end

  it '#import should update previous period when awake for less than two minutes' do
    importer = SleepImporter.new
    start_time = Time.now

    SleepPeriod.create!(starts_at: 1.hour.ago, ends_at: 30.minutes.ago)
    importer.import(start_time, SleepImporter::STATE_SLEEPING)

    period = SleepPeriod.order('starts_at DESC').first

    expect(SleepPeriod.count).to eq 2

    expect(period.starts_at).to  eq start_time
    expect(period.ends_at).to    eq nil
  end


end
