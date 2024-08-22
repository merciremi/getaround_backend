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

    def rental
      @rental ||= Rental.find(rental_id)
    end

    def to_h
      {
        insurance_fee: insurance_fee,
        assistance_fee: assistance_fee,
        drivy_fee: drivy_fee
      }
    end

    private

    def amount
      @amount ||= (rental.price * 0.3).to_i
    end

    def insurance_fee
      (amount * 0.5).to_i
    end

    def assistance_fee
      rental.duration * 100
    end

    def drivy_fee
      amount - insurance_fee - assistance_fee
    end
  end
end
