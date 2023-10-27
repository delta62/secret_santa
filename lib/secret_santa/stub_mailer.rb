# frozen_string_literal: true

module SecretSanta
  class StubMailer
    def send(email:)
      puts "Sending '#{email.subject}'"
      puts "#{email.from} -> #{email.to}"
    end
  end
end
