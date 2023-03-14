# frozen_string_literal: true

require_relative './../vendor/storer/local_store'
require './command_line/save'
require './command_line/query'
require './repository/factory'

module CommandLine
  class Factory
    def initialize(repository_factory = nil)
      @repository_factory = repository_factory || Repository::Factory.new
    end

    def create_save_command(payload)
      CommandLine::Save.new(payload:, repository_factory: @repository_factory)
    end

    def create_query_command(payload)
      CommandLine::Query.new(payload:, repository: @repository_factory.find_by_region_time)
    end
  end
end
