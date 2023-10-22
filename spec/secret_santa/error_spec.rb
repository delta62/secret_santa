# frozen_string_literal: true

require 'secret_santa/error'

RSpec.describe SecretSanta::ImpossibleRansomization do
  it 'returns the given number of participants' do
    err = SecretSanta::ImpossibleRansomization.new(num_participants: 3, largest_group: 2)
    expect(err.num_participants).to be(3)
  end

  it 'returns the given largest group size' do
    err = SecretSanta::ImpossibleRansomization.new(num_participants: 3, largest_group: 2)
    expect(err.largest_group).to be(2)
  end

  it 'is an error' do
    err = SecretSanta::ImpossibleRansomization.new(num_participants: 2, largest_group: 2)
    expect(err).to be_a(StandardError)
  end

  it 'has a sensible message' do
    err = SecretSanta::ImpossibleRansomization.new(num_participants: 3, largest_group: 2)
    expect(err.message).to match(/group of 2.*among 3 participants/)
  end
end
