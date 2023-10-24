# frozen_string_literal: true

module SecretSanta
  class Reporter
    # Create a new reporter. If `redact_recipients` is truthy, the output
    # will obfuscate the generated recipients, only printing out the
    # gifters (and not the giftees)
    def initialize(redact_recipients:)
      # If redacting recipients, we need to sort as well. Otherwise the printed
      # order of assignments would show who is giving to who.
      @sort = redact_recipients
      @redact_recipients = redact_recipients
    end

    def report_participants(participants)
      name_width = max_name_length(participants: participants)
      groups = participants.group_by(&:group)
      anon_group = groups.delete(nil) || []

      puts 'Generating assignments for the following groups and solo participants'
      puts
      puts "== PARTICIPANTS ==\n\n"

      anon_group.each { |p| print_participant(participant: p, name_width: name_width) }
      puts

      groups.sort.each do |group_name, members|
        print_group(group_name: group_name, members: members, name_width: name_width)
      end

      puts unless anon_group.empty?
    end

    def report_assignments(assignments)
      assignments = assignments.sort_by { |a| a.participant.name } if @sort

      first_col_width = max_participant_width(assignments: assignments)

      puts "== ASSIGNMENTS ==\n\n"

      assignments.each do |assignment|
        from = assignment.participant.name.ljust(first_col_width)
        to = @redact_recipients ? '*******' : assignment.gives_to.name
        puts "#{from} -> #{to}"
      end
    end

    private

    def print_group(group_name:, members:, name_width:)
      puts "#{group_name}:"
      members.sort_by(&:name).each do |participant|
        name = participant.name.ljust(name_width)
        puts "    #{name} <#{participant.email}>"
      end

      puts
    end

    def print_participant(participant:, name_width:)
      name = participant.name.ljust(name_width + 4)
      puts "#{name} <#{participant.email}>"
    end

    def max_name_length(participants:)
      participants.map(&:name).map(&:length).max
    end

    def max_participant_width(assignments:)
      assignments.map { |a| a.participant.name.length }.max
    end
  end
end
