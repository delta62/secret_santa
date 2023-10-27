# frozen_string_literal: true

require 'secret_santa/csv_parser'
require 'secret_santa/randomizer'
require 'secret_santa/reporter'

module SecretSanta
  class GiftExchange
    def initialize(redact_recipients:, csv_path:, mailer:, message_builder:)
      @csv_path = csv_path
      @mailer = mailer
      @message_builder = message_builder
      @reporter = Reporter.new(redact_recipients: redact_recipients)
    end

    def assign_and_notify
      participants = parse_csv
      assignments = generate_assignments(participants)

      @reporter.report_participants(participants)
      @reporter.report_assignments(assignments)

      assignments
        .map { |assignment| email_from_assignment(assignment) }
        .each do |email|
          send_email(email)
          log_archive(email)
        end
    end

    private

    def parse_csv
      CsvParser.new(csv_path: @csv_path).parse
    end

    def generate_assignments(participants)
      Randomizer.new(participants: participants).randomize
    end

    def email_from_assignment(assignment)
      @message_builder.build(assignment: assignment)
    end

    def send_email(email)
      @mailer.send(email: email)
    end

    def log_archive(email)
      File.write("log/archive_#{email.to.email}.eml", email.to_s)
    end
  end
end
