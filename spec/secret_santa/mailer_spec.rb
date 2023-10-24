# frozen_string_literal: true

require 'secret_santa/email'
require 'secret_santa/email_address'
require 'secret_santa/mailer'

module SecretSanta
  RSpec.describe Mailer do
    context 'send' do
      it 'uses the given host' do
        expect(mock_smtp).to receive(:start).with('host.example.com', any_args)
        mailer = make_mailer(host: 'host.example.com')
        mailer.send(email: make_email)
      end

      it 'uses the given port' do
        expect(mock_smtp).to receive(:start).with(anything, 42, any_args)
        mailer = make_mailer(port: 42)
        mailer.send(email: make_email)
      end

      it 'converts port numbers to integers' do
        expect(mock_smtp).to receive(:start).with(anything, 42, any_args)
        mailer = make_mailer(port: '42')
        mailer.send(email: make_email)
      end

      it 'uses the given username' do
        expect(mock_smtp).to receive(:start).with(anything, anything, hash_including(user: 'user'))
        mailer = make_mailer(username: 'user')
        mailer.send(email: make_email)
      end

      it 'uses the given password' do
        expect(mock_smtp).to receive(:start).with(anything, anything, hash_including(secret: 'pass'))
        mailer = make_mailer(password: 'pass')
        mailer.send(email: make_email)
      end

      it 'uses the given auth type' do
        expect(mock_smtp).to receive(:start).with(anything, anything, hash_including(authtype: :cram_md5))
        mailer = make_mailer(authtype: :cram_md5)
        mailer.send(email: make_email)
      end

      it "uses the from user's domain as the HELO domain" do
        expect(mock_smtp).to receive(:start).with(anything, anything, hash_including(helo: 'example.com'))
        email = make_email(from: 'foo@example.com')
        make_mailer.send(email: email)
      end

      it 'sends the message' do
        smtp = mock_smtp_with_block
        email = make_email
        expect(smtp).to receive(:send_message).with(email.to_s, any_args)
        make_mailer.send(email: email)
      end

      it "sends from the sending user's address" do
        smtp = mock_smtp_with_block
        email = make_email
        expect(smtp).to receive(:send_message).with(anything, email.from.email, anything)
        make_mailer.send(email: email)
      end

      it "sends to the receiving user's address" do
        smtp = mock_smtp_with_block
        email = make_email
        expect(smtp).to receive(:send_message).with(anything, anything, email.to.email)
        make_mailer.send(email: email)
      end
    end

    def mock_smtp
      class_double('Net::SMTP').as_stubbed_const
    end

    def mock_smtp_with_block
      smtp = spy('smtp')
      expect(mock_smtp).to receive(:start).and_yield(smtp)
      smtp
    end

    # rubocop:disable Metrics/MethodLength
    def make_mailer(username: nil, password: nil, host: nil, port: nil, authtype: nil)
      smtp_host = host || 'host'
      smtp_port = port || 25
      smtp_username = username || 'username'
      smtp_password = password || 'password'
      authtype ||= :plain

      Mailer.new(
        smtp_host: smtp_host,
        smtp_port: smtp_port,
        smtp_username: smtp_username,
        smtp_password: smtp_password,
        authtype: authtype
      )
    end
    # rubocop:enable Metrics/MethodLength

    def make_email(from: nil)
      from ||= 'bob@example.com'
      from = EmailAddress.new(name: 'bob', email: from)
      to = EmailAddress.new(name: 'alice', email: 'alice@example.com')
      subject = 'subject'
      text_content = 'text_content'

      Email.new(from: from, to: to, subject: subject, text_content: text_content)
    end
  end
end
