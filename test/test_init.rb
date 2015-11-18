ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_COLOR'] ||= 'on'
ENV['LOG_LEVEL'] ||= 'trace'

puts RUBY_DESCRIPTION

require_relative '../init.rb'

require 'runner'

require 'event_store/messaging/controls'
require 'securerandom'

Telemetry::Logger::AdHoc.activate
