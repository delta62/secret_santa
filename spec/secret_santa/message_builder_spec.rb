# frozen_string_literal: true

require 'secret_santa/assignment'
require 'secret_santa/message_builder'
require 'secret_santa/participant'

module SecretSanta
  RSpec.describe MessageBuilder do
    let(:from) { EmailAddress.new(name: 'sender', email: 'sender@example.com') }
    let(:give_to) { Participant.new(name: 'alice', email: 'alice@example.com', address1: 'addr1', address2: 'addr2') }
    let(:giver) { Participant.new(name: 'bob', email: 'bob@example.com', address1: '', address2: '') }

    template = <<~BODY
      address line 1: {{address1}}
      address line 2: {{address2}}
      recipient name: {{name}}
    BODY

    it 'sets the subject' do
      builder = make_builder(subject: 'a subject')
      result = builder.build(assignment: make_assignment)
      expect(result.subject).to eq('a subject')
    end

    it 'sets the from email address' do
      result = make_builder.build(assignment: make_assignment)
      expect(result.from.email).to eq(from.email)
    end

    it 'sets the from name' do
      result = make_builder.build(assignment: make_assignment)
      expect(result.from.name).to eq(from.name)
    end

    it 'sets the to email address' do
      result = make_builder.build(assignment: make_assignment)
      expect(result.to.email).to eq(giver.email)
    end

    it 'sets the to name address' do
      result = make_builder.build(assignment: make_assignment)
      expect(result.to.name).to eq(giver.name)
    end

    context 'rendering the message body' do
      it 'provides line 1 of the to address' do
        builder = make_builder(body_template: template)
        result = builder.build(assignment: make_assignment)
        expect(result.to_s).to match("address line 1: #{give_to.address1}")
      end

      it 'provides line 2 of the to address' do
        builder = make_builder(body_template: template)
        result = builder.build(assignment: make_assignment)
        expect(result.to_s).to match("address line 2: #{give_to.address2}")
      end

      it 'provides the recipient name' do
        builder = make_builder(body_template: template)
        result = builder.build(assignment: make_assignment)
        expect(result.to_s).to match("recipient name: #{give_to.name}")
      end
    end

    def make_assignment
      Assignment.new(participant: giver, gives_to: give_to)
    end

    def make_builder(subject: nil, body_template: nil)
      subject ||= 'subject'
      body_template ||= 'body'
      MessageBuilder.new(subject: subject, body_template: body_template, from: from)
    end
  end
end
