# frozen_string_literal: true

# Documentation by Remi - 22 Aug 2024
#
# The module RentalsData is just a support module to move the bulk
# of the input and expected output data from the tests setup.
module RentalsData
  def self.input
    {
      "cars": [
        { "id": 1, "price_per_day": 2000, "price_per_km": 10 }
      ],
      "rentals": [
        { "id": 1, "car_id": 1, "start_date": "2015-12-8", "end_date": "2015-12-8", "distance": 100 },
        { "id": 2, "car_id": 1, "start_date": "2015-03-31", "end_date": "2015-04-01", "distance": 300 },
        { "id": 3, "car_id": 1, "start_date": "2015-07-3", "end_date": "2015-07-14", "distance": 1000 }
      ]
    }
  end

  def self.expected_output
    {
      "rentals": [
        {
          "id": 1,
          "price": 3000,
          "commission": {
            "insurance_fee": 450,
            "assistance_fee": 100,
            "drivy_fee": 350
          }
        },
        {
          "id": 2,
          "price": 6800,
          "commission": {
            "insurance_fee": 1020,
            "assistance_fee": 200,
            "drivy_fee": 820
          }
        },
        {
          "id": 3,
          "price": 27800,
          "commission": {
            "insurance_fee": 4170,
            "assistance_fee": 1200,
            "drivy_fee": 2970
          }
        }
      ]
    }
  end
end
