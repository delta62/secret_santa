# frozen_string_literal: true

module SecretSanta
  class Mailer
    def initialize(smtp_host:, smtp_port:, smtp_username:, smtp_password:)
      @smtp_host = smtp_host
      @smtp_port = smtp_port.to_i
      @smtp_username = smtp_username
      @smtp_password = smtp_password
    end

    def send(email:)
      puts "Send '#{email.subject}' from #{email.from} to #{email.to}"
    end
  end
end
