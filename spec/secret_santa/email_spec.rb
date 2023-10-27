# frozen_string_literal: true

require 'secret_santa/email'
require 'secret_santa/email_address'

module SecretSanta
  RSpec.describe Email do
    context 'to_s' do
      it 'includes the subject' do
        email = setup(subject: 'my subject')
        expect(email.to_s).to match(/^Subject: my subject$/)
      end

      it 'strips whitespace from the subject' do
        email = setup(subject: "\tmy subject    ")
        expect(email.to_s).to match(/^Subject: my subject$/)
      end

      it 'sends from the given from address' do
        from = EmailAddress.new(name: 'alice', email: 'alice@example.com')
        email = setup(from: from)
        expect(email.to_s).to match(/From: alice <alice@example.com>$/)
      end

      it 'sends to the given to address' do
        to = EmailAddress.new(name: 'bob', email: 'bob@example.com')
        email = setup(to: to)
        expect(email.to_s).to match(/To: bob <bob@example.com>$/)
      end

      it 'adds a date header' do
        email = setup
        expect(email.to_s).to match(/^Date: \w+/)
      end

      it 'includes the text content' do
        email = setup(text_content: 'my name is mud')
        expect(email.to_s).to include('my name is mud')
      end

      it 'strips whitespace from the text content' do
        email = setup(text_content: "\tmy name is mud \t  ")
        expect(email.to_s).to match(/^my name is mud$/)
      end
    end

    def setup(subject: nil, text_content: nil, to: nil, from: nil)
      subject ||= 'subject'
      from ||= EmailAddress.new(name: 'sender', email: 'sender@example.com')
      to ||= EmailAddress.new(name: 'recipient', email: 'recipient@example.com')
      text_content ||= ''

      Email.new(subject: subject, from: from, to: to, text_content: text_content)
    end
  end
end
