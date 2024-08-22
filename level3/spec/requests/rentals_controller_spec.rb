# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe Application::RentalsController do
  include RentalsData

  let(:controller) { described_class.new }

  let(:input) { RentalsData.input }
  let(:expected_output) { RentalsData.expected_output }

  before do
    allow(File).to receive(:read).with('data/input.json').and_return(input.to_json)
    allow(File).to receive(:read).with('data/expected_output.json').and_return(expected_output.to_json)
  end

  describe '#export_prices' do
    subject(:export_prices) { controller.export_prices }

    it 'writes the correct output' do
      Tempfile.create('output.json') do |output_file|
        stub_const('Application::RentalsController::OUTPUT_FILE_PATH', output_file.path)

        export_prices

        output_file.rewind
        generated_output = JSON.parse(output_file.read)

        expect(generated_output.to_json).to eq(expected_output.to_json)
      end
    end
  end
end
