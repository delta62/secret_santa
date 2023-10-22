# frozen_string_literal: true

module SecretSanta
  class GroupCache
    def initialize
      @group_num = 0
      @cache = {}
    end

    def group_name(participant)
      return @cache[participant] if @cache.include?(participant)

      if participant.group
        @cache[participant] = participant.group
      else
        @cache[participant] = "__generated_group#{@group_num}".to_sym
        @group_num += 1
      end

      @cache[participant]
    end
  end
end
