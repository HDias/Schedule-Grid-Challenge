# frozen_string_literal: true

module Repository
  class StringParser
    def parse(data_file:, data_query:)
      %(A "#{data_query.region}" #{data_query.time} "#{data_file['region']}" "#{data_file['program_name']}")
    end
  end
end
