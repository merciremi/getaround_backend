# frozen_String_literal: true

module Application
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

    # Documentation by Remi - 21 Aug 2024
    #
    # For the adjusted duration price, I'm okay making the trade-off of the
    # linear time complexity for the loop because it's very readable and easy to understand.
    #
    # I briefly looked for other ways to distribute the duration days based on
    # their discount threshold. I found approches which would result in
    # constant time complexity but were much harder to grasp.
    #
    # So for now, I'll stick with readibility over performance.
    def duration_price
      adjusted_total_price = 0

      (1..duration).each do |day|
        if day > 10
          adjusted_total_price += car.price_per_day * 0.5
        elsif day > 4
          adjusted_total_price += car.price_per_day * 0.7
        elsif day > 1
          adjusted_total_price += car.price_per_day * 0.9
        else
          adjusted_total_price += car.price_per_day
        end
      end

      adjusted_total_price.to_i
    end

    def distance_price = distance * car.price_per_km
  end
end
