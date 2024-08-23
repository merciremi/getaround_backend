# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Car do
  let(:car_data) do
    { id: 1, price_per_day: 1000, price_per_km: 100 }.transform_keys(&:to_s)
  end

  before do
    allow(File).to receive(:read).and_return(JSON.dump({ cars: [car_data] }))
  end

  # Documentation by Remi - 22 Aug 2024
  #
  # This test should now live in a separate file, since this ORM-like method
  # has now been moved into a proper module.
  #
  # I will keep it here for simplicity's sake.
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
