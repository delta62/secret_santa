# frozen_string_literal: true

require 'secret_santa/group_cache'
require 'secret_santa/participant'

module SecretSanta
  RSpec.describe GroupCache do
    context 'participants with a group' do
      it 'returns the group name' do
        participant = make_participant(group: 'group1')
        group_name = GroupCache.new.group_name(participant)
        expect(group_name).to be(:group1)
      end
    end

    context 'participants without a group' do
      it 'returns a calculated group name' do
        group_name = GroupCache.new.group_name(make_participant)
        expect(group_name).to be(:__generated_group0)
      end

      it 'caches calculated group names' do
        participant = make_participant
        cache = GroupCache.new
        group_name1 = cache.group_name(participant)
        group_name2 = cache.group_name(participant)
        expect(group_name1).to be(group_name2)
      end

      it 'returns new group names for new participants' do
        participant1, participant2 = 2.times.map { make_participant }
        cache = GroupCache.new
        group_name1 = cache.group_name(participant1)
        group_name2 = cache.group_name(participant2)
        expect(group_name1).not_to be(group_name2)
      end
    end

    def make_participant(group: nil)
      Participant.new(name: 'name', email: 'email', address1: 'addr1', address2: 'addr2', group: group)
    end
  end
end
