# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Transaction do
  let(:transaction) { described_class.new(1, :owner, :credit, 1000) }

  describe '#to_h' do
    subject(:to_h) { transaction.to_h }

    let(:expected_output) do
      {
        who: :owner,
        type: :credit,
        amount: 1000
      }
    end

    it 'returns the ad hoc values' do
      expect(to_h).to eq(expected_output)
    end
  end
end
