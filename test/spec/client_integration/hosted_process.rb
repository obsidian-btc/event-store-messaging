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
      new events_to_write, message_writer, stream_name
    end

    attr_reader :events_to_write
    attr_reader :message_writer
    attr_reader :stream_name

    def initialize(events_to_write, message_writer, stream_name)
      @events_to_write = events_to_write
      @message_writer = message_writer
      @stream_name = stream_name
    end

    def start(io)
      client.socket = io
      until events_to_write.zero?
        message_writer.write next_message, stream_name
      end
    end

    def connect(io)
      client.establish_connection io
    end

    def next_message
      @events_to_write -= 1
      message = CountdownMessage.new
      message.events_remaining = events_to_write
      message
    end

    def client
      message_writer.writer.request.client
    end
  end

  events_to_read = (ENV["EVENTS_TO_READ"] || 200).to_i
  countdown = events_to_read
  stream_name = "testSubscriptionProcess-#{SecureRandom.uuid}"
  subscription_process = nil

  handler_cls = Class.new do
    include EventStore::Messaging::Handler
    handle CountdownMessage do |message|
      countdown = message.events_remaining
      Telemetry::Logger.get(__FILE__).info "countdown=#{countdown}/#{events_to_read}"
      raise StopIteration if countdown.zero?
    end
  end

  dispatcher_cls = Class.new do
    include EventStore::Messaging::Dispatcher
    handler handler_cls
  end
  dispatcher = dispatcher_cls.new

  writer_process = StreamingWriter.build stream_name, events_to_read
  subscription_process = EventStore::Messaging::Subscription::Process.build stream_name, dispatcher

  process_host = ProcessHost.build do |config|
    config.logger = Telemetry::Logger.get config
    config.poll_period_ms = 200
  end

  begin
    process_host.run do
      add "some-subscription", writer_process
      add "some-subscription", subscription_process
    end
  rescue StopIteration
  end

  specify "Messages are read" do
    assert_equal 0, countdown
  end
end
