# frozen_string_literal: true

require 'csv'
require 'secret_santa/participant'

module SecretSanta
  class CsvParser
    def initialize(csv_path:)
      @csv_path = csv_path
    end

    def parse
      csv = CSV.read(@csv_path)
      csv
        .map { |row| Participant.new(name: row[0], email: row[1]) }
        .group_by(&:email)
    end
  end
end
