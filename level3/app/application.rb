# frozen_string_literal: true

require 'json'
require 'date'
require 'pry-byebug'

require_relative 'models/car'
require_relative 'models/rental'
require_relative 'models/commission'
require_relative 'models/concerns/record'
require_relative 'controllers/rentals_controller'

module Application
  extend Application::Record

  INPUT_FILE_PATH = 'data/input.json'
  OUTPUT_FILE_PATH = 'data/output.json'
end
