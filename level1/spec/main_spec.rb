# frozen_string_literal: true

require 'spec_helper'

# Documentation by Remi - 21 Aug 2024
#
# For unit testing: I'm using hardcoded data and mocking strategies
# to better scope the environment.
#
# For the request-like testing: I'm using input.json and expected_output.json
RSpec.describe Application::Car do
  let(:car_data) do
    { id: 1, price_per_day: 1000, price_per_km: 100 }.transform_keys(&:to_s)
  end

  before do
    allow(File).to receive(:read).and_return(JSON.dump({ cars: [car_data] }))
  end

  describe '.find' do
    subject(:car) { described_class.find(1) }

    it 'returns a car' do
      expect(car).to be_a(Application::Car)
    end

    it 'finds the correct car' do
      expect(car).to have_attributes(id: 1, price_per_day: 1000, price_per_km: 100)
    end
  end
end

RSpec.describe Application::Rental do
  let(:rental) { described_class.new(*rental_data.values) }

  let(:rental_data) do
    { id: 1, car_id: 1, start_date: '2023-08-01', end_date: '2023-08-03', distance: 100 }.transform_keys(&:to_s)
  end
  let(:car_data) do
    { id: 1, price_per_day: 2000, price_per_km: 10 }.transform_keys(&:to_s)
  end

  before do
    allow(File).to receive(:read).and_return(JSON.dump({ cars: [car_data], rentals: [rental_data] }))
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

    it { is_expected.to eq(3) }
  end

  describe '#price' do
    subject(:price) { rental.price }

    it 'calculates the correct price' do
      expect(price).to eq(7000)
    end
  end

  describe '.all' do
    subject(:all) { described_class.all }

    it 'returns a collection of rentals', :aggregate_failures do
      expect(all).to be_an(Array)
      expect(all.first).to be_an(Application::Rental)
    end
  end
end

RSpec.describe Application::RentalsController do
  let(:input_file) { File.read('data/input.json') }
  let(:expected_output_file) { File.read('data/expected_output.json') }
  let(:output_file_path) { 'spec/tmp/output.json' }

  before do
    stub_const('Application::OUTPUT_FILE_PATH', output_file_path)

    allow(File).to receive(:read).and_return(input_file)
  end

  describe '#export_prices' do
    subject(:export_prices) { controller.export_prices }

    let(:controller) { described_class.new }
    let(:expected_output) { JSON.parse(expected_output_file) }

    it 'writes the correct output' do
      export_prices

      generated_output = JSON.parse(File.read(output_file_path))

      expect(generated_output).to eq(expected_output)
    end
  end
end
