# frozen_string_literal: true

require_relative 'concerns/record'

module Application
  # Documentation by Remi - 21 Aug 2024
  #
  # The Car class is currently responsible for storing the raw information fetched
  # from input.json for cars.
  #
  # For convenience ORM-like methods, @see concerns/record
  class Car
    extend Application::Record

    attr_reader :id, :price_per_day, :price_per_km

    def initialize(id, price_per_day, price_per_km)
      @id = id
      @price_per_day = price_per_day
      @price_per_km = price_per_km
    end
  end
end
