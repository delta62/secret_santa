# frozen_string_literal: true

module SecretSanta
  # A single participant in the gift exchange
  class Participant
    attr_reader :name, :email, :group

    def initialize(name:, email:, group: nil)
      @name = name
      @email = email
      @group = group&.to_sym
    end

    def ==(other)
      other.instance_of?(self.class) &&
        @name == other.name &&
        @email == other.email &&
        @group == other.group
    end
  end
end
