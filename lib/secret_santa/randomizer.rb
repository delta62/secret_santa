# frozen_string_literal: true

require 'secret_santa/assignment'

module SecretSanta
  class Randomizer
    def initialize(groups:)
      @keys = groups.keys
      @counts = groups.transform_values(&:length)
      @total_count = @counts.values.sum
      @groups = groups.transform_values(&:shuffle)
      @assignments = []

      return unless @total_count > 1 && @counts.values.any? { |count| count > @total_count / 2 }

      largest_group = @counts.values.max
      raise ImpossibleRansomization.new(num_people: @total_count, largest_group: largest_group)
    end

    def randomize
      return [] if @total_count.zero?
      return [Assignment.self_assignment(@groups.values.first.first)] if @total_count == 1

      group_of_first = random_largest_group
      @first = take_from_group(group: group_of_first)
      @current = @first

      assign_one while more_to_assign?

      last_assignment = Assignment.new(participant: @current, gives_to: @first)
      @assignments << last_assignment

      @assignments
    end

    private

    # Generate one assignment. It is guaranteed that no two members of the
    # same group will be assigned each other.
    def assign_one
      group_of_next = if critical_assignment?
                        critical_group(except: @current.email)
                      else
                        random_largest_group(except: @current.email)
                      end

      gives_to = take_from_group(group: group_of_next)
      assignment = Assignment.new(participant: @current, gives_to: gives_to)
      @current = gives_to

      @assignments.push assignment
    end

    # Once we enter the last 1 participant of each group to assign, we
    # need to use up the final member of the first group, if there is
    # one left. This guarantees that the last participant will not give
    # to the first.
    def critical_assignment?
      assigning_final_members = @total_count <= @groups.length
      last_same_group_as_first = @first.email != @current.email
      has_more_of_first_group = !@groups[@first.email].empty?

      assigning_final_members && !last_same_group_as_first && has_more_of_first_group
    end

    # The group to consider for critical assignments, which prevent
    # the last participant from being in the same group as the first.
    # Because of this, the returned group will always be the group of
    # the first participant.
    def critical_group
      @keys[@first.email]
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

    def more_to_assign?
      !@total_count.zero?
    end
  end

  # It is impossible to randomize the given groups, because at least
  # one group is more than 1/2 the size of the total participant pool
  class ImpossibleRansomization < StandardError
    def initialize(num_people:, largest_group:)
      super("Cannot randomize an exclusive group of #{largest_group} people among #{num_people} participants")
    end
  end
end
