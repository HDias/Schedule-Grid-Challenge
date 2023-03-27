# frozen_string_literal: true

module Repository
  class ScheduleFindByRegionTime
    def initialize(parser:, storer:)
      @parser ||= parser
      @storer ||= storer
    end

    def call(data:)
      schedules = []

      file_data&.each do |value|
        schedules << @parser.parse(data_file: value, data_query: data) if match?(data, value)
      end

      schedules
    end

    private

    def match?(data, value)
      value['region'] == data.region and data.time.between?(value['begin_time'], value['end_time'])
    end

    def file_data
      @storer.load
    end
  end
end
