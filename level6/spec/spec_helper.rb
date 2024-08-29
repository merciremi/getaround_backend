# frozen_string_literal: true

require 'rspec'
require 'json'
require 'pry-byebug'

require_relative '../app/application'
require_relative '../app/models/car'
require_relative '../app/models/rental'
require_relative '../app/models/commission'
require_relative '../app/models/transaction'
require_relative '../app/models/option'
require_relative '../app/models/discount_schedule'
require_relative '../app/models/concerns/record'
require_relative '../app/controllers/rentals_controller'

require_relative 'support/rentals_data'
