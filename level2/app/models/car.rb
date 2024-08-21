# frozen_string_literal: true

module Application
  # Documentation by Remi - 21 Aug 2024
  #
  # The Car class is currently responsible for storing the raw information fetched
  # from input.json for cars.
  #
  # Right now it handles ORM-style methods. These will move into a proper abstraction
  # later down the road.
  class Car
    attr_reader :id, :price_per_day, :price_per_km

    def initialize(id, price_per_day, price_per_km)
      @id = id
      @price_per_day = price_per_day
      @price_per_km = price_per_km
    end

    class << self
      def find(id)
        cars = fetch_cars

        # Later, we could raise an error if no car is found
        car_attributes = cars.find { |car| car['id'] == id }

        new(*car_attributes.values)
      end

      private

      def fetch_cars
        JSON.parse(File.read(INPUT_FILE_PATH))['cars']
      end
    end
  end
end
