# frozen_string_literal: true

require 'rantly'
require 'rantly/rspec_extensions'
require 'rantly/shrinks'
require 'secret_santa/participant'
require 'secret_santa/randomizer'

def make_random_participants
  group_count = range(0, 10)
  participants = []
  largest_group_size = 0

  group_count.times do |i|
    group_size = range(1, 5)
    largest_group_size = [largest_group_size, group_size].max
    group_size.times do |j|
      name = "group#{i}_user#{j}"
      email = "#{name}@example.com"
      group = group_size == 1 ? nil : "group#{i}"
      p = SecretSanta::Participant.new(name: name, email: email, group: group)
      participants.push(p)
    end
  end

  participant_count = participants.length
  padding_participant_count = (largest_group_size * 2) - participant_count

  if padding_participant_count.positive?
    padding_participant_count.times do |i|
      name = "padding_user_#{i}"
      email = "#{name}@example.com"
      p = SecretSanta::Participant.new(name: name, email: email)
      participants.push(p)
      participant_count += 1
    end
  end

  participants
end

RSpec.describe SecretSanta::Randomizer do
  it 'produces the same number of assignments as there are participants' do
    property_of do
      participants = make_random_participants
      participant_count = participants.length
      rand = SecretSanta::Randomizer.new(participants: participants)
      result = rand.randomize

      [participant_count, result]
    end.check(100) do |participant_count, result|
      expect(result.length).to be(participant_count)
    end
  end

  it 'includes everyone as a gifter exactly once' do
    property_of do
      participants = make_random_participants
      participant_count = participants.length
      rand = SecretSanta::Randomizer.new(participants: participants)
      result = rand.randomize

      [participant_count, result]
    end.check(100) do |participant_count, result|
      unique_gifters = result.map(&:participant).uniq.length
      expect(unique_gifters).to be(participant_count)
    end
  end

  it 'includes everyone as a recipient exactly once' do
    property_of do
      participants = make_random_participants
      participant_count = participants.length
      rand = SecretSanta::Randomizer.new(participants: participants)
      result = rand.randomize

      [participant_count, result]
    end.check(100) do |participant_count, result|
      unique_recipients = result.map(&:gives_to).uniq.length
      expect(unique_recipients).to be(participant_count)
    end
  end

  it 'never assigns two members of the same group to one another' do
    property_of do
      participants = make_random_participants
      rand = SecretSanta::Randomizer.new(participants: participants)
      rand.randomize
    end.check(1_000) do |assignments|
      assignments.each do |assignment|
        from = assignment.participant
        to = assignment.gives_to
        next if from.group.nil? && to.group.nil?

        expect(from.group).not_to eq(to.group)
      end
    end
  end
end
