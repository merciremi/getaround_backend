# frozen_string_literal: true

require_relative 'concerns/record'

module Application
  # Documentation by Remi - 21 Aug 2024
  #
  # The Rental class is currently responsible for storing the raw information fetched
  # from input.json for rentals.
  #
  # It also defines: calculations such as duration or price.
  #
  # For convenience ORM-like methods, @see concerns/record
  class Rental
    class StartDateAfterEndDate < StandardError; end

    extend Application::Record

    attr_reader :id, :car_id, :start_date, :end_date, :distance, :commission, :discount_schedule, :transactions

    def initialize(id, car_id, start_date, end_date, distance)
      @id = id
      @car_id = car_id
      @start_date = Date.parse(start_date)
      @end_date = Date.parse(end_date)
      @distance = distance

      @commission = Commission.new(self.id)
      @discount_schedule = DiscountSchedule.new(duration)
    end

    def car
      @car ||= Car.find(car_id)
    end

    def duration
      raise StartDateAfterEndDate, 'Start date is after end date' if start_date > end_date

      (start_date..end_date).count
    end

    def base_price
      @base_price ||= duration_price + distance_price
    end

    def price
      @price ||= base_price + options_price
    end

    def net_payout
      @net_payout ||= price - commission.amount
    end

    def transactions
      @transactions ||= debit_transactions + credit_transactions
    end

    def options
      @options ||= Option.where(rental_id: id)
    end

    private

    def distance_price = distance * car.price_per_km

    def duration_price
      (
        discount_schedule.days_for_first_tier * car.price_per_day +
        discount_schedule.days_for_second_tier * car.price_per_day * discount_schedule.second_tier_discount +
        discount_schedule.days_for_third_tier * car.price_per_day * discount_schedule.third_tier_discount +
        discount_schedule.days_for_fourth_tier * car.price_per_day * discount_schedule.fourth_tier_discount
      ).to_i
    end

    def options_price
      options.sum(&:price) * duration
    end

    # Documentation by Remi - 22 Aug 2024
    #
    # The following amounts are taken into account:
    # - rental.price
    def debit_transactions
      @_debit_transactions ||= begin
        transactions = []

        transactions << Transaction.new(id, :driver, :debit, price)
      end
    end

    # Documentation by Remi - 22 Aug 2024
    #
    # The following amounts are taken into account:
    # - rental.net_payout
    # - commission.insurance_fee
    # - commission.assistance_fee
    # - commission.drivy_fee + options_payable_to_getaround
    def credit_transactions
      @_credit_transactions ||= begin
        transactions = []

        transactions << Transaction.new(id, :owner, :credit, net_payout)

        [:insurance, :assistance, :drivy].each do |recipient|
          fee_amount = commission.send("#{recipient}_fee")

          transactions << Transaction.new(id, recipient, :credit, fee_amount)
        end

        transactions
      end
    end
  end
end
