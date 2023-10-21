# frozen_string_literal: true

require 'secret_santa/participant'

RSpec.describe SecretSanta::Participant do
  it 'returns the correct name' do
    p = make_participant(name: 'timmy')
    expect(p.name).to be('timmy')
  end

  it 'returns the correct email address' do
    p = make_participant(email: 'foo@example.com')
    expect(p.email).to be('foo@example.com')
  end

  context '==' do
    it 'returns true for an identical participant' do
      a1 = make_participant(name: 'a', email: 'a@example.com')
      a2 = make_participant(name: 'a', email: 'a@example.com')
      expect(a1).to eq(a2)
    end

    it 'returns false for nil' do
      p = make_participant
      expect(p).not_to eq(nil)
    end

    it 'returns false for a different class' do
      p = make_participant
      expect(p).not_to eq('a string')
    end

    it 'returns false when names differ' do
      p1 = make_participant(name: 'Alice')
      p2 = make_participant(name: 'Bob')
      expect(p1).not_to eq(p2)
    end

    it 'returns false when emails differ' do
      p1 = make_participant(email: 'alice@example.com')
      p2 = make_participant(email: 'bob@example.com')
      expect(p1).not_to eq(p2)
    end
  end

  def make_participant(email: nil, name: nil)
    name ||= 'jdoe'
    email ||= 'jdoe@example.com'

    SecretSanta::Participant.new(email: email, name: name)
  end
end
