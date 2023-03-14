# frozen_string_literal: true

module Repository
  class HashParser
    def parse(data:)
      {
        region: data.region,
        program_name: data.program_name,
        begin_time: data.begin_time,
        end_time: data.end_time
      }
    end
  end
end
