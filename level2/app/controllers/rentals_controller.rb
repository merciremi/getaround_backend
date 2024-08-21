# frozen_string_literal: true

module Application
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
