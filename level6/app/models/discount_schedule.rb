# frozen_string_literal: true

module Application
  # Documentation by Remi - 29 Aug 2024
  #
  # The DiscountSchedule class is responsible for:
  # - configuring the tiers schedule
  # - appyling the tiers schedule to the rental duration
  #
  # As of now, the tiers schedule is hardcoded but adding configuration through
  # env variables or at initialization are within reach, if we ever need it.
  class DiscountSchedule
    attr_reader :duration, :minimum_duration,
                :days_until_second_tier, :days_until_third_tier, :days_until_fourth_tier,
                :second_tier_discount, :third_tier_discount, :fourth_tier_discount

    # I left _tiers as a reminder that we could pass a collection of custom instructions
    # at initialization. We, then, could dynamically generate methods for both the
    # threshold and the discount values.
    def initialize(duration, _tiers = [])
      @duration = duration

      @minimum_duration = 1

      @days_until_second_tier = 1
      @days_until_third_tier = 4
      @days_until_fourth_tier = 10

      @second_tier_discount = 0.9
      @third_tier_discount = 0.7
      @fourth_tier_discount = 0.5
    end

    def days_for_first_tier
      [duration, first_tier].min
    end

    def days_for_second_tier
      [[duration - first_tier, 0].max, second_tier].min
    end

    def days_for_third_tier
      [[duration - second_tier, 0].max, third_tier].min
    end

    def days_for_fourth_tier
      [fourth_tier, 0].max
    end

    private

    def first_tier
      (minimum_duration..days_until_second_tier).count
    end

    def second_tier
      (days_until_second_tier + 1..days_until_third_tier).count
    end

    def third_tier
      (days_until_third_tier + 1..days_until_fourth_tier).count
    end

    def fourth_tier
      (days_until_fourth_tier + 1..duration).count
    end
  end
end
