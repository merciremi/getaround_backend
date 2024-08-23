# frozen_string_literal: true

module Application
  # Documentation by Remi - 22 Aug 2024
  #
  # The Record class is currently responsible for extending convenience class methods
  # in the vibe of Rails ORM.
  module Record
    class NotFoundError < StandardError; end

    def find(id)
      resources = fetch(tableize(self.name))

      resource_attributes = resources.find { |resource| resource['id'] == id }

      raise Record::NotFoundError, "No instance of #{name} was found with id: #{id}" if resource_attributes.nil?

      new(*resource_attributes.values)
    end

    def where(args)
      resources = fetch(tableize(self.name))

      filtered_resources =
        resources.select do |resource|
          args.all? do |column_name, value|
            value = [value] unless value.is_a?(Array)
            value.include?(resource[column_name.to_s])
          end
        end

      filtered_resources.map { |resource_attributes| new(*resource_attributes.values) }
    end

    def all
      resources = fetch(tableize(self.name))

      resources.map { |resource_attributes| new(*resource_attributes.values) }
    end

    private

    def tableize(klass_name)
      "#{klass_name.split('::').last.downcase}s"
    end

    def fetch(table_name)
      JSON.parse(File.read(INPUT_FILE_PATH))[table_name]
    end
  end
end
