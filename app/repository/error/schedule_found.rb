# frozen_string_literal: true

module Repository
  module Error
    class ScheduleFound < StandardError
      def initialize(program_name:)
        super

        @program_name = program_name
      end

      def message
        "O programa: #{@program_name}, já está cadastrado!"
      end
    end
  end
end
