# string_literal: true

require 'spec_helper'

RSpec.describe Application::Commission do
  let(:rental_data) do
    { id: 1, car_id: 1, start_date: '2015-12-8', end_date: '2015-12-8', distance: 100 }.transform_keys(&:to_s)
  end
  let(:car_data) do
    { id: 1, price_per_day: 1000, price_per_km: 10 }.transform_keys(&:to_s)
  end
  let(:option_data) do
    { id: 1, rental_id: 1, type: 'gps' }.transform_keys(&:to_s)
  end

  let(:commission) { described_class.new(rental_data['id']) }

  before do
    allow(File).to receive(:read).and_return(JSON.dump({ cars: [car_data], rentals: [rental_data], options: [option_data] }))
  end

  describe '#to_h' do
    subject(:to_h) { commission.to_h }

    let(:expected_output) { { insurance_fee: 300, assistance_fee: 100, drivy_fee: 200 } }

    it 'returns the ad hoc attributes' do
      expect(to_h).to eq(expected_output)
    end
  end
end
