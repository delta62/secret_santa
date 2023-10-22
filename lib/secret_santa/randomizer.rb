# frozen_string_literal: true

require 'secret_santa/assignment'
require 'secret_santa/error'
require 'secret_santa/group_cache'

module SecretSanta
  class Randomizer
    def initialize(participants:)
      @group_cache = GroupCache.new
      @groups = participants.group_by { |participant| group_name(participant) }
      @groups.each(&:shuffle!)

      @keys = @groups.keys
      @counts = @groups.transform_values(&:length)
      @total_count = @counts.values.sum
      @assignments = []

      validate_group_sizes
    end

    def randomize
      return [] if @total_count.zero?
      return [Assignment.self_assignment(@groups.values.first.first)] if @total_count == 1

      @first = take_from_group(group: random_largest_group)
      @current = @first

      assign_one while more_to_assign?

      @assignments << Assignment.new(participant: @current, gives_to: @first)
    end

    private

    def validate_group_sizes
      return unless @total_count > 1 && @counts.values.any? { |count| count > @total_count / 2 }

      largest_group = @counts.values.max
      raise ImpossibleRansomization.new(num_participants: @total_count, largest_group: largest_group)
    end

    # Generate one assignment. It is guaranteed that no two members of the
    # same group will be assigned each other.
    def assign_one
      group_of_next = if critical_assignment?
                        group_name(@first)
                      else
                        random_largest_group(except: group_name(@current))
                      end

      gives_to = take_from_group(group: group_of_next)
      assignment = Assignment.new(participant: @current, gives_to: gives_to)
      @current = gives_to

      @assignments << assignment
    end

    # Once we enter the last 1 participant of each group to assign, we
    # need to use up the final member of the first group, if there is
    # one left. This guarantees that the last participant will not be
    # in the same group as the first.
    def critical_assignment?
      first_group = group_name(@first)
      current_group = group_name(@current)
      assigning_final_members = @total_count <= @groups.length
      last_same_group_as_first = first_group == current_group
      has_more_of_first_group = !@groups[first_group].empty?

      assigning_final_members && !last_same_group_as_first && has_more_of_first_group
    end

    # Selects one of the groups with the most members at random, but will
    # never select `except`.
    def random_largest_group(except: nil)
      @keys.filter { |key| key != except }
           .shuffle!
           .max_by { |key| @counts[key] }
    end

    def take_from_group(group:)
      @total_count -= 1
      @counts[group] -= 1
      @groups[group].pop
    end

    def group_name(participant)
      @group_cache.group_name(participant)
    end

    def more_to_assign?
      !@total_count.zero?
    end
  end
end
