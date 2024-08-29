# frozen_string_literal: true

module Application
  # Documentation by Remi - 21 Aug 2024
  #
  # The RentalsController class is currently responsible for exposing the
  # public method responsible for exporting the prices of all rentals to
  # output.json
  #
  # I've tried to move toward a RESTful structure (despite using a custom endpoint):
  # - Fetch the resource.
  # - Operation on the resource.
  # - Response.
  #
  # Some improvements that could be made:
  # - Move serialization details to an ad hoc abstraction.
  # - Add rescuing mechanism for common errors such as Record::NotFoundError.
  # - Adjust response based on the resource.
  class RentalsController
    def export
      File.open(OUTPUT_FILE_PATH, 'w') do |file|
        file.write JSON.pretty_generate(rental_prices)
      end

      [200, { 'Content-Type' => 'text/html' }, []]

    # Errors that could be rescued:
    # - Errno::ENOENT (file can't be created)
    # - Errno::EACCES (permissions)
    rescue StandardError => e
      error_response = {
        status: 400,
        error: 'Bad Request',
        message: 'An error occurred while processing your request.',
        details: e.message
      }

      [400, { 'Content-Type' => 'application/json' }, [error_response.to_json]]
    end

    private

    def rentals
      @rentals ||= Rental.all
    end

    def rental_prices
      {
        rentals: rentals.map do |rental|
          {
            id: rental.id,
            options: rental.options.map(&:type),
            actions: rental.transactions.map(&:to_h)
          }
        end
      }
    end
  end
end
