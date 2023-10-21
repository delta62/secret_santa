# frozen_string_literal: true

require 'secret_santa/assignment'
require 'secret_santa/participant'
require 'secret_santa/randomizer'

RSpec.describe SecretSanta::Randomizer do
  context 'initialize' do
    it 'raises when given a group larger than 1/2 the total pool of participants' do
      groups = make_groups(foo: 3, bar: 2)
      expect { SecretSanta::Randomizer.new(groups: groups) }.to raise_error(SecretSanta::ImpossibleRansomization)
    end

    it 'does not raise when given small groups' do
      groups = make_groups(foo: 2, bar: 2)
      expect(SecretSanta::Randomizer.new(groups: groups)).to be_instance_of(SecretSanta::Randomizer)
    end
  end

  context 'randomize' do
    it 'returns an empty array for a group of 0 participants' do
      rand = randomizer_with_groups({})
      expect(rand.randomize).to eq([])
    end

    it 'returns an array of one item giving to themselves for 1 participant' do
      rand = randomizer_with_groups({ foo: 1 })
      result = rand.randomize

      expect(result.length).to be(1)
    end

    it 'self-assigns a single participant' do
      rand = randomizer_with_groups({ foo: 1 })
      result = rand.randomize
      participant = SecretSanta::Participant.new(name: 'foo #0', email: '0@foo.com')
      self_assignment = SecretSanta::Assignment.self_assignment(participant)

      expect(result.first).to eq(self_assignment)
    end

    it 'returns an array of equal length to the number of participants' do
      rand = randomizer_with_groups({ foo: 3, bar: 2, baz: 1 })
      result = rand.randomize
      expect(result.length).to be(6)
    end
  end

  def randomizer_with_groups(groups)
    groups = make_groups(groups)
    SecretSanta::Randomizer.new(groups: groups)
  end

  def make_groups(groups)
    ret = {}

    groups.each do |key, count|
      participants = count.times.map do |i|
        SecretSanta::Participant.new(name: "#{key} ##{i}", email: "#{i}@#{key}.com")
      end
      ret[key] = participants
    end

    ret
  end
end
