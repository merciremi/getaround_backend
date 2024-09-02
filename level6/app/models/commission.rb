# frozen_string_literal: true

module Application
  # Documentation by Remi - 22 Aug 2024
  #
  # The Commission class is currently responsible for computing various fees.
  #
  # For convenience ORM-like methods, @see concerns/record
  class Commission
    attr_reader :rental_id

    def initialize(rental_id)
      @rental_id = rental_id
    end

    def amount
      insurance_fee + assistance_fee + drivy_fee
    end

    def insurance_fee
      @insurance_fee ||= (base_amount * 0.5).to_i
    end

    def assistance_fee
      @assistance_fee ||= rental.duration * 100
    end

    def drivy_fee
      # Drive fee could be negative if rental.duration is long AND car.price_per_day is low
      #
      # We might want to add a flat fee instead as a fallback, or validation on
      # car and rentals.
      @drivy_fee ||= base_amount - insurance_fee - assistance_fee + rental_options
    end

    def to_h
      {
        insurance_fee: insurance_fee,
        assistance_fee: assistance_fee,
        drivy_fee: drivy_fee
      }
    end

    private

    def rental
      @rental ||= Rental.find(rental_id)
    end

    def rental_options
      rental.options.payable_to_getaround.sum(&:price) * rental.duration
    end

    def base_amount
      @base_amount ||= (rental.base_price * 0.3).to_i
    end
  end
end
