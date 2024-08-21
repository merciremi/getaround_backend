# frozen_string_literal: true

require 'json'
require 'date'
require 'pry-byebug'

# Documentation by Remi - 21 Aug 2024
#
# The Application class is a simple wrapper for config-like information,
# and allow for a single point of entry.
class Application
  INPUT_FILE_PATH = 'data/input.json'
  OUTPUT_FILE_PATH = 'data/output.json'

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

  # Documentation by Remi - 21 Aug 2024
  #
  # The Rental class is currently responsible for storing the raw information fetched
  # from input.json for rentals.
  #
  # Right now it handles ORM-style methods. These will move into a proper abstraction
  # later down the road.
  class Rental
    attr_reader :id, :car_id, :start_date, :end_date, :distance

    def initialize(id, car_id, start_date, end_date, distance)
      @id = id
      @car_id = car_id
      @start_date = Date.parse(start_date)
      @end_date = Date.parse(end_date)
      @distance = distance
    end

    def car
      @car ||= Car.find(car_id)
    end

    def duration = (start_date..end_date).count

    def price = duration_price + distance_price

    class << self
      def all
        rentals = fetch_rentals

        rentals.map { |rental_attributes| Rental.new(*rental_attributes.values) }
      end

      private

      def fetch_rentals
        JSON.parse(File.read(INPUT_FILE_PATH))['rentals']
      end
    end

    private

    def duration_price = duration * car.price_per_day

    def distance_price = distance * car.price_per_km
  end

  # Documentation by Remi - 21 Aug 2024
  #
  # The RentalsController class is currently responsible for exposing the
  # public method responsible for exporting the prices of all rentals to
  # output.json
  #
  # Right now it handles serialization details. These might move later on.
  class RentalsController
    def export_prices
      File.open(OUTPUT_FILE_PATH, 'w') do |file|
        file.write JSON.pretty_generate(rental_prices)
      end
    end

    private

    def rental_prices
      {
        rentals: Rental.all.map { |rental| { id: rental.id, price: rental.price } }
      }
    end
  end
end

# Documentation by Remi - 21 Aug 2024
#
# Right now, RSpec runs the whole of main.rb, since I didn't separate each
# class in its own file. Thus, rspec creates an output.json in /data.
Application::RentalsController.new.export_prices
