# frozen_string_literal: true

module Application
  # Documentation by Remi - 22 Aug 2024
  #
  # The Record class is currently responsible for extending convenience class methods
  # in the vibe of Rails ORM.
  module Record
    def find(id)
      resources = fetch(tableize(self.name))

      # Later, we could raise an error if no car is found
      resource_attributes = resources.find { |resource| resource['id'] == id }

      new(*resource_attributes.values)
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
