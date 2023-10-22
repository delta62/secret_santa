# frozen_string_literal: true

require 'csv'
require 'secret_santa/participant'

module SecretSanta
  class CsvParser
    def initialize(csv_path:)
      @csv = CSV.read(csv_path)
    end

    # Parse the csv at the given `csv_path`, returning an array
    # of participant objects.
    # No header row is parsed, the first row is treated as data.
    # Each row should contain 2-3 values: a name, an email address,
    # and an optional group name.
    def parse
      @csv.map do |row|
        name, email, group = row
        Participant.new(name: name, email: email, group: group)
      end
    end
  end
end
