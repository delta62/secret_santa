# frozen_string_literal: true

require 'secret_santa/assignment'
require 'secret_santa/participant'
require 'secret_santa/randomizer'

module SecretSanta
  RSpec.describe Randomizer do
    context 'initialize' do
      it 'raises when given a group larger than 1/2 the total pool of participants' do
        participants = make_groups(foo: 3, bar: 2)
        expect { Randomizer.new(participants: participants) }.to raise_error(ImpossibleRansomization)
      end

      it 'does not raise when given small groups' do
        participants = make_groups(foo: 2, bar: 2)
        expect(Randomizer.new(participants: participants)).to be_instance_of(Randomizer)
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
        participant = Participant.new(name: 'foo #0', email: '0@foo.com', address1: '123 fake st',
                                      address2: 'Seattle, WA  98107', group: 'foo')
        self_assignment = Assignment.self_assignment(participant)

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
      SecretSanta::Randomizer.new(participants: groups)
    end

    def make_groups(groups)
      ret = []

      groups.each do |group, count|
        count.times.each do |i|
          name = "#{group} ##{i}"
          email = "#{i}@#{group}.com"
          p = SecretSanta::Participant.new(name: name, email: email, address1: '123 fake st',
                                           address2: 'Seattle, WA  98107', group: group)
          ret.push(p)
        end
      end

      ret
    end
  end
end
