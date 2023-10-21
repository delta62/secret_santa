# frozen_string_literal: true

require 'secret_santa/assignment'

module SecretSanta
  class Randomizer
    def initialize(groups:)
      @keys = groups.keys
      @counts = groups.transform_values(&:length)
      @total_count = @counts.values.sum
      @groups = groups
      @assignments = []

      return unless @total_count > 1 && @counts.values.any? { |count| count > @total_count / 2 }

      largest_group = @counts.values.max
      raise ImpossibleRansomization.new(num_people: @total_count, largest_group: largest_group)
    end

    def randomize
      return [] if @total_count.zero?
      return [Assignment.self_assignment(@groups.values.first.first)] if @total_count == 1

      group_of_first = largest_group
      @first = take_from_group(group: group_of_first)
      @current = @first

      assign_one while more_to_assign?

      last_assignment = Assignment.new(participant: @current, gives_to: @first)
      @assignments << last_assignment

      @assignments
    end

    private

    def assign_one
      group_of_next = largest_group(except: @current.email)
      give_to = take_from_group(group: group_of_next)

      assignment = Assignment.new(participant: @current, gives_to: give_to)
      @current = give_to

      @assignments.push assignment
    end

    def largest_group(except: nil)
      @keys.filter { |key| key != except }.max_by { |key| @counts[key] }
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
