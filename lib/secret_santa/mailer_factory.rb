# frozen_string_literal: true

require 'secret_santa/mailer'
require 'secret_santa/stub_mailer'

module SecretSanta
  class MailerFactory
    def initialize(dry_run:, smtp_host:, smtp_port:, smtp_username:, smtp_password:, authtype:)
      @dry_run = dry_run
      @smtp_host = smtp_host
      @smtp_port = smtp_port
      @smtp_password = smtp_password
      @smtp_username = smtp_username
      @authtype = authtype
    end

    def build
      if @dry_run
        create_stub_mailer
      else
        create_mailer
      end
    end

    private

    def create_stub_mailer
      StubMailer.new
    end

    def create_mailer
      SecretSanta::Mailer.new(
        smtp_host: @smtp_host,
        smtp_port: @smtp_port,
        smtp_username: @smtp_username,
        smtp_password: @smtp_password,
        authtype: @authtype
      )
    end
  end
end
