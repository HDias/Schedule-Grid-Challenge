# frozen_string_literal: true

module Repository
  module Error
    class ScheduleNotFound < StandardError
      def initialize(region:, time:)
        super

        @region = region
        @time = time
      end

      def message
        %(A "#{@region}" #{@time}' noise)
      end
    end
  end
end
