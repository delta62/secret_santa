# frozen_string_literal: true

module SecretSanta
  # It is impossible to randomize the given groups, because at least
  # one group is more than 1/2 the size of the total participant pool
  class ImpossibleRansomization < StandardError
    attr_reader :num_participants, :largest_group

    def initialize(num_participants:, largest_group:)
      @num_participants = num_participants
      @largest_group = largest_group
      super("Cannot randomize an exclusive group of #{largest_group} people among #{num_participants} participants")
    end
  end
end
