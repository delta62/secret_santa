# frozen_string_literal: true

require 'rspec/core/rake_task'

task default: %i[spec property]

task :run, [:csv_file] do |_task, args|
  csv_file = args[:csv_file] || 'people'
  ruby 'bin/secret_santa', "res/#{csv_file}.csv"
end

# Unit tests
spec_task = RSpec::Core::RakeTask.new(:spec)
spec_task.exclude_pattern = 'spec/property/*_spec.rb'

# Property-based testing
ENV['RANTLY_VERBOSE'] = '0'
property_task = RSpec::Core::RakeTask.new(:property)
property_task.exclude_pattern = 'spec/secret_santa/*_spec.rb'
property_task.rspec_opts = '--format documentation'
