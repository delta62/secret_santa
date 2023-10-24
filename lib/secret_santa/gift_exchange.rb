# frozen_string_literal: true

require 'secret_santa/email'
require 'secret_santa/email_address'
require 'secret_santa/csv_parser'
require 'secret_santa/participant'
require 'secret_santa/randomizer'
require 'secret_santa/reporter'
require 'secret_santa/mailer'

module SecretSanta
  class GiftExchange
    def initialize(redact_recipients:, csv_path:, mailer:)
      @redact_recipients = redact_recipients
      @csv_path = csv_path
      @mailer = mailer
    end

    def assign_and_notify
      participants = CsvParser.new(csv_path: @csv_path).parse
      reporter = Reporter.new(redact_recipients: @redact_recipients)

      reporter.report_participants(participants)

      randomizer = Randomizer.new(participants: participants)
      assignments = randomizer.randomize

      reporter.report_assignments(assignments)

      emails = assignments.map { |assignment| email_from_assignment(assignment) }
      emails.each { |email| @mailer.send(email: email) }
    end

    private

    def email_from_assignment(assignment)
      from = EmailAddress.new(name: assignment.participant.name, email: assignment.participant.email)
      to = EmailAddress.new(name: assignment.gives_to.name, email: assignment.gives_to.email)
      Email.new(from: from, to: to, subject: 'aaaa', text_content: 'bbbbbb')
    end
  end
end
