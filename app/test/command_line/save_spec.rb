# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'
require_relative './../../command_line/save'
require_relative './../../vendor/storer/local_store'
require_relative './../../repository/factory'
require_relative './../../repository/error/schedule_found'
require 'minitest/byebug' if ENV['DEBUG']

describe CommandLine::Save do
  describe '#call' do
    it 'should be match valid command' do
      valid_save_command = 'S "DF" "Bom Dia DF" 06:00 07:30'

      save_command_line = CommandLine::Save.new(payload: valid_save_command, repository_factory: nil)

      assert_equal('DF', save_command_line.region)
      assert_equal('Bom Dia DF', save_command_line.program_name)
      assert_equal('06:00', save_command_line.begin_time)
      assert_equal('07:30', save_command_line.end_time)
    end

    it 'should not be match invalid command' do
      invalid_save_command = 'Z "DF" "Bom Dia DF" 06:00 07:30'

      assert_raises(ArgumentError, 'Comando inválido. Digite help para obter ajuda') do
        CommandLine::Save.new(payload: invalid_save_command, repository_factory: nil)
      end
    end

    it 'should raise a ArgumentException' do
      save_command = 'S "DF" "Bom Dia DF" 07:31 07:30'

      assert_raises(ArgumentError, 'hora:minuto de início deve ser menor que hora:minuto fim') do
        CommandLine::Save.new(payload: save_command, repository_factory: nil)
      end
    end

    it 'should raise if program_name exists' do
      valid_save_command = 'S "DF" "Bom Dia DF" 07:30 08:30'

      save_command_line = CommandLine::Save.new(payload: valid_save_command, repository_factory: repository_factory)
      save_command_line.execute

      save_command_line = CommandLine::Save.new(payload: valid_save_command, repository_factory: repository_factory)

      assert_raises(Repository::Error::ScheduleFound, "O programa: Bom Dia DF, já está cadastrado!") do
        save_command_line.execute
      end

      drop_file
    end

    it 'should save payload ' do
      valid_save_command = 'S "DF" "Bom Dia DF" 07:30 08:30'

      save_command_line = CommandLine::Save.new(payload: valid_save_command, repository_factory: repository_factory)

      save_command_line.execute

      assert_equal('Salvo com Sucesso!', save_command_line.messages.first)

      data_file = local_storer.load
      data_file = data_file.first

      assert_equal('DF', data_file['region'])
      assert_equal('Bom Dia DF', data_file['program_name'])
      assert_equal('07:30', data_file['begin_time'])
      assert_equal('08:30', data_file['end_time'])

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
