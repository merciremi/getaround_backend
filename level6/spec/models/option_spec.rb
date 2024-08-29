# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Option do
  let(:option) { described_class.new(1, 1, type) }

  describe '#price' do
    subject(:price) { option.price }

    context 'when the type is :gps' do
      let(:type) { :gps }

      it { is_expected.to eq(500) }
    end

    context 'when the type is :baby_seat' do
      let(:type) { :baby_seat }

      it { is_expected.to eq(200) }
    end

    context 'when the type is :additional_insurance' do
      let(:type) { :additional_insurance }

      it { is_expected.to eq(1_000) }
    end
  end
end
