# frozen_string_literal: true

module Application
  # Documentation by Remi - 22 Aug 2024
  #
  # The Record class is currently responsible for extending convenience class methods
  # in the vibe of Rails ORM.
  module Record
    class NotFoundError < StandardError; end

    def scope(...)
      Collection.scope(...)
    end

    def find(id)
      resources = fetch(tableize(self.name))

      resource_attributes = resources.find { |resource| resource['id'] == id }

      raise Record::NotFoundError, "No instance of #{name} was found with id: #{id}" if resource_attributes.nil?

      new(*resource_attributes.values)
    end

    def where(args)
      resources = fetch(tableize(self.name))
      resources = resources.map { |resource_attributes| new(*resource_attributes.values) }

      Collection.new(self, resources).where(args)
    end

    def all
      resources = fetch(tableize(self.name))
      resources = resources.map { |resource_attributes| new(*resource_attributes.values) }

      Collection.new(self, resources)
    end

    private

    def tableize(klass_name)
      "#{klass_name.split('::').last.downcase}s"
    end

    def fetch(table_name)
      JSON.parse(File.read(INPUT_FILE_PATH))[table_name]
    end

    # Documentation by Remi - 2 Sep 2024
    #
    # The class Record::Collection is responsible for encapsulating a collection of records.
    # It allows us to define chainable scopes or chainable where methods on records,
    # making the coupling between different models looser.
    #
    # Also implements other methods usually defined on Array.
    class Collection
      attr_reader :records

      def initialize(klass, records = nil, filters = {})
        @klass = klass
        @records = records
        @filters = filters
      end

      def self.scope(name, block)
        define_method(name, &block)
      end

      def where(args)
        new_filters = @filters.merge(args)

        filtered_records =
          records.select do |record|
            new_filters.all? do |column_name, value|
              value = [value] unless value.is_a?(Array)
              value.include? record.send(column_name)
            end
          end

        self.class.new(@klass, filtered_records)
      end

      def map(&block)
        records.map(&block)
      end

      def sum(&block)
        records.sum(&block)
      end

      def +(other)
        self.class.new(@klass, records + other.records)
      end

      def first
        records.first
      end
    end
  end
end
