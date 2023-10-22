# frozen_string_literal: true

require 'secret_santa/group_cache'
require 'secret_santa/participant'

RSpec.describe SecretSanta::GroupCache do
  context 'participants with a group' do
    it 'returns the group name' do
      participant = make_participant(group: 'group1')
      group_name = make_cache.group_name(participant)
      expect(group_name).to be(:group1)
    end
  end

  context 'participants without a group' do
    it 'returns a calculated group name' do
      group_name = make_cache.group_name(make_participant)
      expect(group_name).to be(:__generated_group0)
    end

    it 'caches calculated group names' do
      participant = make_participant
      cache = make_cache
      group_name1 = cache.group_name(participant)
      group_name2 = cache.group_name(participant)
      expect(group_name1).to be(group_name2)
    end

    it 'returns new group names for new participants' do
      participant1, participant2 = 2.times.map { make_participant }
      cache = make_cache
      group_name1 = cache.group_name(participant1)
      group_name2 = cache.group_name(participant2)
      expect(group_name1).not_to be(group_name2)
    end
  end

  def make_cache
    SecretSanta::GroupCache.new
  end

  def make_participant(group: nil)
    SecretSanta::Participant.new(name: 'name', email: 'email', group: group)
  end
end
