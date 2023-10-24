# frozen_string_literal: true

module SecretSanta
  # A single participant in the gift exchange
  class Participant
    attr_reader :name, :email, :group, :address1, :address2

    def initialize(name:, email:, address1:, address2:, group: nil)
      @name = name
      @email = email
      @address1 = address1
      @address2 = address2
      @group = group&.to_sym
    end

    def ==(other)
      other.instance_of?(self.class) &&
        @name == other.name &&
        @email == other.email &&
        @group == other.group &&
        @address1 == other.address1 &&
        @address2 == other.address2
    end
  end
end
