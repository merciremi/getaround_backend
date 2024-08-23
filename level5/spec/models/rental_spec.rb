# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Rental do
  let(:rental) { described_class.new(*rental_data.values) }

  let(:rental_data) do
    { id: 1, car_id: 1, start_date: '2015-12-8', end_date: '2015-12-8', distance: 100 }.transform_keys(&:to_s)
  end
  let(:car_data) do
    { id: 1, price_per_day: 2000, price_per_km: 10 }.transform_keys(&:to_s)
  end
  let(:option_data) do
    { id: 1, rental_id: 1, type: 'gps' }.transform_keys(&:to_s)
  end

  before do
    allow(File).to receive(:read).and_return(JSON.dump({ cars: [car_data], rentals: [rental_data], options: [option_data] }))
  end

  describe '#car' do
    subject(:car) { rental.car }

    it 'returns the ad hoc car', :aggregate_failures do
      expect(car).to be_a(Application::Car)
      expect(car).to have_attributes(id: 1, price_per_day: 2000, price_per_km: 10)
    end
  end

  describe '#duration' do
    subject(:duration) { rental.duration }

    it { is_expected.to eq(1) }
  end

  describe '#base_price' do
    subject(:base_price) { rental.base_price }

    it 'calculates the correct base price' do
      expect(base_price).to eq(3000)
    end
  end

  describe '#price' do
    subject(:price) { rental.price }

    it 'calculates the correct price' do
      expect(price).to eq(3500)
    end
  end

  describe '#net_payout' do
    subject(:net_payout) { rental.net_payout }

    # Duration price: 2000 +
    # Distance price: 1OOO +
    # Options price: 500 -
    # 900 (30% of Duration price + Distance price)
    it 'calculates the net payout for the owner' do
      expect(net_payout).to eq(2600)
    end
  end

  describe '#transactions' do
    subject(:transactions) { rental.transactions }

    let(:expected_types) { %i[driver owner insurance assistance drivy] }

    it 'returns a collection of transactions', :aggregate_failures do
      expect(transactions).to be_an(Array)
      expect(transactions.map(&:class).uniq).to eq([Application::Transaction])
    end

    it 'returns transactions for each type of transaction' do
      expect(transactions.map(&:recipient)).to eq(expected_types)
    end
  end

  # Documentation by Remi - 22 Aug 2024
  #
  # This test should now live in a separate file, since this ORM-like method
  # has now been moved into a proper module.
  #
  # I will keep it here for simplicity's sake.
  describe '.all' do
    subject(:all) { described_class.all }

    it 'returns a collection of rentals', :aggregate_failures do
      expect(all).to be_an(Array)
      expect(all.first).to be_an(Application::Rental)
    end
  end
end
