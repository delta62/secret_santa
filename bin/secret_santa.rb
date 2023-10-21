#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
require_relative '../lib/secret_santa/randomizer'

file = ARGV.first
csv = CSV.read(file)
participants = csv
               .map { |row| Participant.new(name: row[0], email: row[1]) }
               .group_by(&:email)
               .transform_values(&:shuffle!)

randomizer = Randomization.new(groups: participants)
result = randomizer.randomize

result.each do |assignment|
  puts "#{assignment.participant.name} -> #{assignment.gives_to.name}"
end
