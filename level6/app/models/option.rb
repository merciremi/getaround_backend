# frozen_string_literal: true

module Application
  class Option
    extend Application::Record

    PRICES_FOR_TYPES = { gps: 500, baby_seat: 200, additional_insurance: 1_000 }.freeze
    OWNER_FRIENDLY_TYPES = %w[gps baby_seat].freeze
    GETAROUND_FRIENDLY_TYPES = %w[additional_insurance].freeze

    attr_reader :id, :rental_id, :type

    def initialize(id, rental_id, type)
      @id = id
      @rental_id = rental_id
      @type = type
    end

    def price
      @price ||= PRICES_FOR_TYPES[type.to_sym]
    end
  end
end
