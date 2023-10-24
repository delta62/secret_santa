# frozen_string_literal: true

require 'secret_santa/email_address'

module SecretSanta
  RSpec.describe EmailAddress do
    it 'returns the given email address' do
      address = EmailAddress.new(name: 'bob', email: 'bob@example.com')
      expect(address.email).to eq('bob@example.com')
    end

    context 'domain' do
      it 'returns the domain part' do
        address = EmailAddress.new(name: 'bob', email: 'bob@example.com')
        expect(address.domain).to eq('example.com')
      end
    end

    context 'to_s' do
      it 'formats the name and email together' do
        address = EmailAddress.new(name: 'bob', email: 'bob@example.com')
        expect(address.to_s).to eq('bob <bob@example.com>')
      end
    end
  end
end
