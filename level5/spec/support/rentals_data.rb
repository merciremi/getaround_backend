# frozen_string_literal: true

# Documentation by Remi - 22 Aug 2024
#
# The module RentalsData is just a support module to move the bulk
# of the input and expected output data from the tests setup.
module RentalsData
  def self.input
    {
      cars: [
        { id: 1, price_per_day: 2000, price_per_km: 10 }
      ],
      rentals: [
        { id: 1, car_id: 1, start_date: '2015-12-08', end_date: '2015-12-08', distance: 100 },
        { id: 2, car_id: 1, start_date: '2015-03-31', end_date: '2015-04-01', distance: 300 },
        { id: 3, car_id: 1, start_date: '2015-07-03', end_date: '2015-07-14', distance: 1_000 }
      ],
      options: [
        { id: 1, rental_id: 1, type: 'gps' },
        { id: 2, rental_id: 1, type: 'baby_seat' },
        { id: 3, rental_id: 2, type: 'additional_insurance' }
      ]
    }
  end

  def self.expected_output
    {
      rentals: [
        {
          id: 1,
          options: ['gps', 'baby_seat'],
          actions: [
            { who: 'driver', type: 'debit', amount: 3_700 },
            { who: 'owner', type: 'credit', amount: 2_800 },
            { who: 'insurance', type: 'credit', amount: 450 },
            { who: 'assistance', type: 'credit', amount: 100 },
            { who: 'drivy', type: 'credit', amount: 350 }
          ]
        },
        {
          id: 2,
          options: ['additional_insurance'],
          actions: [
            { who: 'driver', type: 'debit', amount: 8_800 },
            { who: 'owner', type: 'credit', amount: 4_760 },
            { who: 'insurance', type: 'credit', amount: 1_020 },
            { who: 'assistance', type: 'credit', amount: 200 },
            { who: 'drivy', type: 'credit', amount: 2_820 }
          ]
        },
        {
          id: 3,
          options: [],
          actions: [
            { who: 'driver', type: 'debit', amount: 27_800 },
            { who: 'owner', type: 'credit', amount: 19_460 },
            { who: 'insurance', type: 'credit', amount: 4_170 },
            { who: 'assistance', type: 'credit', amount: 1_200 },
            { who: 'drivy', type: 'credit', amount: 2_970 }
          ]
        }
      ]
    }
  end
end
