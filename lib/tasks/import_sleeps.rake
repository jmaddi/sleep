require_relative '../sleep_importer'
require 'csv'

namespace :import_sleeps do
  desc 'Imports sleep periods from text file'
  task :import_file, [:filename] => [:environment] do |t, args|
    file = args[:filename]
    importer = SleepImporter.new

    CSV.foreach(file, col_sep: ':') do |row|
      importer.import(Time.at(row[0].to_i), row[1].to_i)
    end

    SleepPeriod.where("strftime('%s', ends_at)-strftime('%s', starts_at) < 120").destroy_all
  end
end
