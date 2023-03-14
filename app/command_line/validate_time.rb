# frozen_string_literal: true

module CommandLine
  class ValidateTime
    def begin_less_than_end(begin_time:, end_time:)
      begin_time < end_time
    end
  end
end
