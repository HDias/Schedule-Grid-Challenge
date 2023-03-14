# frozen_string_literal: true

require 'json'

module Storer
  class LocalStore
    FOLDER_PATH = '/usr/src/app/storage/'
    FILE_NAME = 'programm_schedules.json'

    def initialize(persister: File, parser: JSON, options: {})
      @persister = persister
      @parser    = parser
      @options   = options
    end

    def persist(payload:)
      process(payload:)
    end

    def load
      data = nil

      if @persister.exist?(full_path)
        file = @persister.read(full_path)

        data = @parser.parse(file)
      end

      data
    end

    private

    def process(payload:)
      data = load || []

      data << payload

      store(data)
    end

    def store(data)
      @persister.write(full_path, @parser.dump(data))
    end

    def folder_path
      @options[:folder_path] || FOLDER_PATH
    end

    def file_name
      @options[:file_name] || FILE_NAME
    end

    def full_path
      @persister.join(folder_path, file_name)
    end
  end
end
