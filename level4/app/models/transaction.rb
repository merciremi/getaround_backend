# frozen_string_literal: true

module Application
  # Documentation by Remi - 22 Aug 2024
  #
  # The Transaction class is currently responsible for handling and formatting
  # the information regarding monetary transactions.
  #
  # As of now, the class is not making any use of rental_id and could be nested
  # under models/rentals/transaction.rb
  #
  # I've kept it here since in a real-life situation, Transaction would certainly
  # have its own table and relationships.
  class Transaction
    attr_reader :rental_id, :recipient, :type, :amount

    def initialize(rental_id, recipient, type, amount)
      @rental_id = rental_id
      @recipient = recipient
      @type = type
      @amount = amount
    end

    def to_h
      {
        who: recipient,
        type: type,
        amount: amount
      }
    end
  end
end
