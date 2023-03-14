# frozen_string_literal: true

require_relative 'validate_time'
require_relative './../repository/hash_parser'
require_relative './../repository/schedule_create'
require_relative './../repository/error/schedule_found'
require 'json'

module CommandLine
  class Save
    attr_accessor :messages
    attr_reader :region, :program_name, :begin_time, :end_time

    def initialize(payload:, repository_factory:)
      @payload            = payload
      @repository_factory = repository_factory

      fill_attibutes
    end

    def execute
      raise Repository::Error::ScheduleFound.new(program_name: @program_name) if schedule_exists?

      save_schedule

      @messages = ['Salvo com Sucesso!']
    end

    private

    def save_schedule
      @repository_factory.create.call(data: self)
    end

    def schedule_exists?
      @repository_factory.find_by_program_name.call(program_name: @program_name)
    end

    def match
      /^S\s+"([^"]+)"\s+"([^"]+)"\s+(\d{2}:\d{2})\s+(\d{2}:\d{2})$/.match(@payload)
    end

    def fill_attibutes
      raise ArgumentError, 'Comando inválido. Digite help para obter ajuda.' unless match

      @region       = match[1]
      @program_name = match[2]
      @begin_time   = match[3]
      @end_time     = match[4]

      validate_time(begin_time: @begin_time, end_time: @end_time)
    end

    def validate_time(begin_time:, end_time:, validate_time: CommandLine::ValidateTime.new)
      begin_less_than_end = validate_time.begin_less_than_end(begin_time:, end_time:)

      return if begin_less_than_end

      raise ArgumentError, 'hora:minuto de início deve ser menor que hora:minuto fim'
    end
  end
end
