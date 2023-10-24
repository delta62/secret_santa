# frozen_string_literal: true

require 'net/smtp'

module SecretSanta
  class Mailer
    def initialize(smtp_host:, smtp_port:, smtp_username:, smtp_password:, authtype:)
      @smtp_host = smtp_host
      @smtp_port = smtp_port.to_i
      @smtp_username = smtp_username
      @smtp_password = smtp_password
      @authtype = authtype
    end

    def send(email:)
      Net::SMTP.start(
        @smtp_host,
        @smtp_port,
        helo: email.from.domain,
        user: @smtp_username,
        secret: @smtp_password,
        authtype: @authtype
      ) do |smtp|
        smtp.send_message(email.to_s, email.from.email, email.to.email)
      end
    end
  end
end
