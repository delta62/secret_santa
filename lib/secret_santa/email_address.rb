# frozen_string_literal: true

module SecretSanta
  class EmailAddress
    attr_reader :email

    def initialize(name:, email:)
      @name = name.strip
      @email = email.strip
    end

    def domain
      domain_start = @email.index('@') + 1
      @email.slice(domain_start..)
    end

    def to_s
      "#{@name} <#{@email}>"
    end
  end
end
