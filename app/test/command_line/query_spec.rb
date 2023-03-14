# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'
require_relative './../../command_line/query'
require_relative './../../command_line/save'
require_relative './../../vendor/storer/local_store'
require_relative './../../repository/factory'
require_relative './../../repository/error/schedule_not_found'
require 'minitest/byebug' if ENV['DEBUG']

describe CommandLine::Query do
  describe '#call' do
    it 'should be match valid command' do
      valid_query_command = 'Q "GO" 05:30'

      query_command_line = CommandLine::Query.new(payload: valid_query_command, repository: nil)

      assert_equal('GO', query_command_line.region)
      assert_equal('05:30', query_command_line.time)
    end

    it 'should not be match invalid command' do
      invalid_query_command = 'Z "GO" 05:30'

      assert_raises(ArgumentError, 'Comando inválido. Digite help para obter ajuda') do
        CommandLine::Query.new(payload: invalid_query_command, repository: nil)
      end
    end

    it 'should raise ScheduleNotFound' do
      query_command = 'Q "GO" 05:30'
      query_command_line = CommandLine::Query.new(
        payload: query_command,
        repository: repository_factory.find_by_region_time
      )

      assert_raises(Repository::Error::ScheduleNotFound, 'A "GO" 05:30 noise') do
        query_command_line.execute
      end
    end

    it 'should find program schedule after save' do
      valid_save_command = 'S "DF" "Bom Dia DF" 07:30 08:30'
      save_command_line_1 = CommandLine::Save.new(payload: valid_save_command, repository_factory: repository_factory)
      save_command_line_1.execute

      valid_save_command = 'S "GO" "Bom Dia GO" 07:30 08:30'
      save_command_line_2 = CommandLine::Save.new(payload: valid_save_command, repository_factory: repository_factory)
      save_command_line_2.execute

      valid_query_command = 'Q "DF" 07:34'
      query_command_line = CommandLine::Query.new(
        payload: valid_query_command,
        repository: repository_factory.find_by_region_time
      )
      schedules = query_command_line.execute

      assert_equal(1, schedules.length)

      drop_file
    end

    def drop_file(path_file: '/usr/src/app/test/files/programm_schedules.json')
      FileUtils.rm_f(path_file)
    end

    def repository_factory
      Repository::Factory.new(
        local_storer
      )
    end

    def local_storer
      storer_options = { folder_path: '/usr/src/app/test/files/' }

      Storer::LocalStore.new(options: storer_options)
    end
  end
end
