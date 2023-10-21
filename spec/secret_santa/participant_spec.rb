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

  it 'returns the correct group' do
    p = make_participant(group: 'foos')
    expect(p.group).to be(:foos)
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
      alice = make_participant(name: 'Alice')
      bob = make_participant(name: 'Bob')
      expect(alice).not_to eq(bob)
    end

    it 'returns false when groups differ' do
      foo_user = make_participant(group: 'foo')
      bar_user = make_participant(group: 'bar')
      expect(foo_user).not_to eq(bar_user)
    end

    it 'returns false when emails differ' do
      alice = make_participant(email: 'alice@example.com')
      bob = make_participant(email: 'bob@example.com')
      expect(alice).not_to eq(bob)
    end
  end

  def make_participant(email: nil, name: nil, group: nil)
    name ||= 'jdoe'
    email ||= 'jdoe@example.com'
    group ||= 'users'

    SecretSanta::Participant.new(email: email, name: name, group: group)
  end
end
