# frozen_string_literal: true

require_relative 'validate_time'
require_relative './../repository/error/schedule_not_found'

module CommandLine
  class Query
    attr_accessor :messages
    attr_reader :region, :time

    def initialize(payload:, repository:)
      @payload    ||= payload
      @repository ||= repository

      fill_attibutes
    end

    def execute
      schedules = @repository.call(data: self)

      raise Repository::Error::ScheduleNotFound.new(region: @region, time: @time) if schedules.empty?

      handle_messages(schedules)
    end

    private

    def handle_messages(schedules)
      @messages = []

      schedules.each { |resource| @messages << resource }
    end

    def match
      /^Q\s+"([^"]+)"\s+(\d{2}:\d{2})$/.match(@payload)
    end

    def fill_attibutes
      raise ArgumentError, 'Comando inválido. Digite help para obeter ajuda.' unless match

      @region = match[1]
      @time   = match[2]
    end
  end
end
