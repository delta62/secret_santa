# frozen_string_literal: true

require 'secret_santa/assignment'

RSpec.describe SecretSanta::Assignment do
  it 'returns the correct participant' do
    a = make_assignment(from: 'bob')
    expect(a.participant).to eq('bob')
  end

  it 'returns the correct recipient' do
    a = make_assignment(to: 'alice')
    expect(a.gives_to).to eq('alice')
  end

  context 'self_assignment' do
    it 'sets the recipient to the participant' do
      a = SecretSanta::Assignment.self_assignment('bob')
      expect(a.participant).to be(a.gives_to)
    end
  end

  context '==' do
    it 'returns true when both participant and recipeint are equal' do
      a1 = make_assignment(from: 'bob', to: 'alice')
      a2 = make_assignment(from: 'bob', to: 'alice')
      expect(a1).to eq(a2)
    end

    it 'returns false when participants differ' do
      from_bob = make_assignment(from: 'bob', to: 'timmy')
      from_alice = make_assignment(from: 'alice', to: 'timmy')
      expect(from_bob).not_to eq(from_alice)
    end

    it 'returns false when recipients differ' do
      to_timmy = make_assignment(from: 'alice', to: 'timmy')
      to_bob = make_assignment(from: 'alice', to: 'bob')
      expect(to_timmy).not_to eq(to_bob)
    end

    it 'retuns false when compared to nil' do
      expect(make_assignment).not_to eq(nil)
    end

    it 'returns false when compared to a different class' do
      expect(make_assignment).not_to eq(42)
    end
  end

  def make_assignment(from: 'from_user', to: 'to_user')
    SecretSanta::Assignment.new(participant: from, gives_to: to)
  end
end
