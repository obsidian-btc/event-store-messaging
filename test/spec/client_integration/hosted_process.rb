require_relative 'client_integration_init'

require 'process_host'

describe "Hosting a subscription process" do
  class CountdownMessage
    include EventStore::Messaging::Message
    attribute :events_remaining
  end

  class StreamingWriter
    def self.build(stream_name, events_to_write)
      message_writer = EventStore::Messaging::Writer.build
      instance = new events_to_write, message_writer, stream_name
      Telemetry::Logger.configure instance
      instance
    end

    dependency :logger

    attr_reader :events_to_write
    attr_reader :message_writer
    attr_reader :stream_name

    def initialize(events_to_write, message_writer, stream_name)
      @events_to_write = events_to_write
      @message_writer = message_writer
      @stream_name = stream_name
    end

    def start
      until events_to_write.zero?
        logger.pass "Wrote event ##{events_to_write}"
        message_writer.write next_message, stream_name
      end
    end

    def next_message
      @events_to_write -= 1
      message = CountdownMessage.new
      message.events_remaining = events_to_write
      message
    end

    def session
      message_writer.writer.request.session
    end

    module ProcessHostIntegration
      def change_connection_scheduler(scheduler)
        session.connection.scheduler = scheduler
      end
    end
  end

  events_to_read = (ENV["EVENTS_TO_READ"] || 3).to_i
  countdown = events_to_read
  stream_name = "testSubscriptionProcess-#{SecureRandom.uuid}"
  subscription_process = nil

  handler_cls = Class.new do
    include EventStore::Messaging::Handler
    handle CountdownMessage do |message|
      countdown = message.events_remaining
      Telemetry::Logger.get(__FILE__).info "countdown=#{countdown}/#{events_to_read}"
      logger.pass "Countdown is down to #{countdown}"
      raise StopIteration if countdown.zero?
    end
  end

  dispatcher_cls = Class.new do
    include EventStore::Messaging::Dispatcher
    handler handler_cls
  end
  dispatcher = dispatcher_cls.new

  writer_process = StreamingWriter.build stream_name, events_to_read
  subscription = EventStore::Messaging::Subscription.build stream_name, dispatcher

  cooperation = ProcessHost::Cooperation.build
  cooperation.register writer_process, 'writer'
  cooperation.register subscription, 'subscription'

  t0 = Time.now
  begin
    cooperation.start
  rescue StopIteration
  end
  t1 = Time.now
  delta = t1 - t0

  Telemetry::Logger.get(__FILE__).warn "#{events_to_read} events in #{Rational(delta, 1).to_f.round(2)}s; #{Rational(events_to_read, delta).to_f.round(2)}m/s"

  specify "Messages are read" do
    assert_equal 0, countdown
  end
end
