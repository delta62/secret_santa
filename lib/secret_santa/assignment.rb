# frozen_string_literal: true

module SecretSanta
  # An assignment for one participant to give to another
  class Assignment
    attr_reader :participant, :gives_to

    def initialize(participant:, gives_to:)
      @participant = participant
      @gives_to = gives_to
    end

    def self.self_assignment(participant)
      new(participant: participant, gives_to: participant)
    end

    def ==(other)
      other.instance_of?(self.class) &&
        @participant == other.participant &&
        @gives_to == other.gives_to
    end
  end
end
