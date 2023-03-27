# frozen_string_literal: true

module Repository
  class ScheduleCreate
    def initialize(parser:, storer:)
      @parser ||= parser
      @storer ||= storer
    end

    def call(data:)
      payload = @parser.parse(data:)

      @storer.persist(payload:)
    end
  end
end
