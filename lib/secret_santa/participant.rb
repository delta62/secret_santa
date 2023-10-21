# frozen_string_literal: true

module SecretSanta
  # A single participant in the gift exchange
  class Participant
    attr_reader :name, :email

    def initialize(name:, email:)
      @name = name
      @email = email
    end

    def ==(other)
      other.instance_of?(self.class) &&
        @name == other.name &&
        @email == other.email
    end
  end
end
