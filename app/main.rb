# frozen_string_literal: true

require './command_line/factory'
require './command_line/invoker'
require './repository/error/schedule_found'
require './repository/error/schedule_not_found'
require 'minitest/byebug' if ENV['DEBUG']

command_factory = CommandLine::Factory.new

invoker = CommandLine::Invoker.new
puts invoker.help_message

loop do
  input = gets.chomp
  first_command = input.split.first

  begin
    case first_command
    when 'S'
      invoker.on_start = command_factory.create_save_command(input)
      invoker.execute
    when 'Q'
      invoker.on_start = command_factory.create_query_command(input)
      invoker.execute
    when /\Ahelp\z/i
      puts invoker.help_message
    when /\Aclear\z/i
      puts "\e[H\e[2J"
    when /\Aexit\z/i
      printf 'bye!'
      puts "\n"
      break
    else
      puts 'Comando Inválido. Digite help'
    end
  rescue ArgumentError => e
    puts e.message
  rescue Repository::Error::ScheduleFound => e
    puts e.message
  rescue Repository::Error::ScheduleNotFound => e
    puts e.message
  rescue Exception => e
    puts "Erro inesperado: #{e.message}"
  end
end
