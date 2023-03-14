# frozen_string_literal: true

module Repository
  class ScheduleFindByProgramName
    def initialize(storer:)
      @storer = storer
    end

    def call(program_name:)
      return nil unless file_data

      file_data.each do |value|
        return value if match?(program_name, value)
      end

      nil
    end

    private

    def match?(program_name, value)
      value['program_name'] == program_name
    end

    def file_data
      @storer.load
    end
  end
end
