# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'
require_relative './../../command_line/validate_time'

describe CommandLine::ValidateTime do
  describe '#begin_less_than_end' do
    it 'should be return true when begin_time is less than end_time' do
      begin_time = '07:00'
      end_time   = '08:00'

      validate_time = CommandLine::ValidateTime.new

      assert(validate_time.begin_less_than_end(begin_time:, end_time:))
    end

    it 'should be return false when begin_time is equal end_time' do
      begin_time = '07:00'
      end_time   = '07:00'

      validate_time = CommandLine::ValidateTime.new

      refute(validate_time.begin_less_than_end(begin_time:, end_time:))
    end

    it 'should be return false when begin_time is greater than end_time' do
      begin_time = '07:00'
      end_time   = '06:00'

      validate_time = CommandLine::ValidateTime.new

      refute(validate_time.begin_less_than_end(begin_time:, end_time:))
    end
  end
end
