# frozen_string_literal: true

require_relative 'app/application'

Application::RentalsController.new.export_prices
