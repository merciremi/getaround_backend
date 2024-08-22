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
          "actions": [
            {
              "who": "driver",
              "type": "debit",
              "amount": 3000
            },
            {
              "who": "owner",
              "type": "credit",
              "amount": 2100
            },
            {
              "who": "insurance",
              "type": "credit",
              "amount": 450
            },
            {
              "who": "assistance",
              "type": "credit",
              "amount": 100
            },
            {
              "who": "drivy",
              "type": "credit",
              "amount": 350
            }
          ]
        },
        {
          "id": 2,
          "actions": [
            {
              "who": "driver",
              "type": "debit",
              "amount": 6800
            },
            {
              "who": "owner",
              "type": "credit",
              "amount": 4760
            },
            {
              "who": "insurance",
              "type": "credit",
              "amount": 1020
            },
            {
              "who": "assistance",
              "type": "credit",
              "amount": 200
            },
            {
              "who": "drivy",
              "type": "credit",
              "amount": 820
            }
          ]
        },
        {
          "id": 3,
          "actions": [
            {
              "who": "driver",
              "type": "debit",
              "amount": 27800
            },
            {
              "who": "owner",
              "type": "credit",
              "amount": 19460
            },
            {
              "who": "insurance",
              "type": "credit",
              "amount": 4170
            },
            {
              "who": "assistance",
              "type": "credit",
              "amount": 1200
            },
            {
              "who": "drivy",
              "type": "credit",
              "amount": 2970
            }
          ]
        }
      ]
    }
  end
end
