# frozen_string_literal: true

module SecretSanta
  class Reporter
    # Create a new reporter. If `redact_recipients` is truthy, the output
    # will obfuscate the generated recipients, only printing out the
    # gifters (and not the giftees)
    def initialize(redact_recipients:)
      @sort = redact_recipients
      @redact_recipients = redact_recipients
    end

    def report(assignments:)
      assignments = assignments.sort_by { |a| a.participant.name } if @sort

      first_col_width = max_participant_width(assignments: assignments)

      assignments.each do |assignment|
        from = assignment.participant.name.ljust(first_col_width)
        to = @redact_recipients ? '*******' : assignment.gives_to.name
        puts "#{from} -> #{to}"
      end
    end

    private

    def max_participant_width(assignments:)
      assignments.map { |assn| assn.participant.name.length }.max
    end
  end
end
