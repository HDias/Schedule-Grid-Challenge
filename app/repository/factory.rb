# frozen_string_literal: true

require_relative './schedule_create'
require_relative './hash_parser'
require_relative './../vendor/storer/local_store'
require_relative './schedule_find_by_region_time'
require_relative './string_parser'
require_relative './schedule_find_by_program_name'

module Repository
  class Factory
    def initialize(storer = nil)
      @storer ||= storer
    end

    def create
      Repository::ScheduleCreate.new(
        parser: Repository::HashParser.new,
        storer:
      )
    end

    def find_by_region_time
      Repository::ScheduleFindByRegionTime.new(
        parser: Repository::StringParser.new,
        storer:
      )
    end

    def find_by_program_name
      Repository::ScheduleFindByProgramName.new(
        storer:
      )
    end

    private

    def storer
      @storer || Storer::LocalStore.new
    end
  end
end
