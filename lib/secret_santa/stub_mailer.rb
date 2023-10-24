# frozen_string_literal: true

module SecretSanta
  class StubMailer
    def send(email:)
      puts "Send '#{email.subject}' from #{email.from} to #{email.to}"
    end
  end
end
