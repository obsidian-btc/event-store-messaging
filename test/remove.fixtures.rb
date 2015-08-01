module Fixtures
  class SomeEvent
    include EventStore::Messaging::Message

    attribute :some_attribute
    attribute :some_time

    attribute :handlers, Array, default: [], lazy: true

    def handler?(handler)
      handler_name = handler if handler.instance_of? String
      handler_name ||= handler.name if handler.instance_of? Class

      handlers.any? { |handler_class| handler_class.name.end_with? handler_name }
    end

    def handled?
      handlers.length > 0
    end
  end

  class AnotherMessage < SomeEvent
  end

  class SomeHandler
    include EventStore::Messaging::Handler

    handle SomeEvent do |message|
      message.handlers << self.class
    end
  end

  class OtherHandler
    include EventStore::Messaging::Handler

    handle SomeEvent do |message, stream_entry|
      message.handlers << self.class
      stream_entry.data[:some_side_effect] = :effected
    end
  end

  class AnotherHandler
    include EventStore::Messaging::Handler

    handle AnotherMessage do |message|
      message.handlers << self.class
    end
  end

  class ConfiguredHandler
    include EventStore::Messaging::Handler

    attr_accessor :configured_dependencies

    def configure_dependencies
      self.configured_dependencies = true
    end
  end

  class SomeDispatcher
    include EventStore::Messaging::Dispatcher

    handler SomeHandler
    handler OtherHandler
    handler AnotherHandler
  end

  class SingleDispatcher
    include EventStore::Messaging::Dispatcher

    handler SomeHandler
  end

  class SomeRegistry
    include EventStore::Messaging::Registry
  end

  class SomeMessage
    include EventStore::Messaging::Message
    attribute :some_attribute
  end

  class SomeOtherMessage < SomeMessage
  end

  def self.reader
    EventStore::Messaging::Reader::Substitute.build
  end

  def self.dispatcher
    SomeDispatcher.new
  end

  def self.handler
    SomeHandler.new
  end

  def self.message
    SomeEvent.new
  end

  def self.some_message
    SomeMessage.new
  end

  def self.some_message_with_metadata
    message = SomeMessage.new
    message.metadata = Metadata.metadata
    message
  end

  def self.some_other_message
    SomeOtherMessage.new
  end

  def self.registry
    SomeRegistry.new
  end

  def self.stream_entry_data
    {
      id: '10000000-0000-0000-0000-000000000000',
      type: 'SomeEvent',
      number: 1,
      position: 11,
      stream_name: 'someStream',
      uri: 'http://127.0.0.1:2113/streams/someStream/1',
      updated: '2015-06-08T04:37:01.066935Z',
      data: {
        some_attribute: 'some value'
      },
      metadata: {
        source_stream_name: 'some_source_stream',
        correlation_stream_name: 'some_correlation_stream',
        causation_event_id: 'some_causation_event_id',
        causation_stream_name: 'some_causation_stream',
        reply_stream_name: 'some_reply_stream',
        version: -1
      }
    }
  end

  def self.stream_entry
    EventStore::Client::HTTP::Stream::Entry.build stream_entry_data
  end

  module Metadata
    def self.uuid
      UUID.random
    end

    def self.event_id
      uuid
    end

    def self.source_stream_id
      uuid
    end

    def self.source_stream_name
      "sourceStream-#{source_stream_id}"
    end

    def self.correlation_stream_id
      uuid
    end

    def self.correlation_stream_name
      "correlationStream-#{correlation_stream_id}"
    end

    def self.causation_event_id
      uuid
    end

    def self.causation_stream_id
      uuid
    end

    def self.causation_stream_name
      "causationStream-#{causation_stream_id}"
    end

    def self.reply_stream_id
      uuid
    end

    def self.reply_stream_name
      "replyStream-#{reply_stream_id}"
    end

    def self.version
      -1
    end

    def self.metadata
      metadata = EventStore::Messaging::Message::Metadata.new
      metadata.event_id = event_id
      metadata.source_stream_name = source_stream_name
      metadata.correlation_stream_name = correlation_stream_name
      metadata.causation_event_id = causation_event_id
      metadata.causation_stream_name = causation_stream_name
      metadata.reply_stream_name = reply_stream_name
      metadata.version = version

      metadata
    end
  end

  module Anomalies
    class SomeHandler
      include EventStore::Messaging::Handler

      handle SomeEvent do |message|
        message.handlers << self.class.name
      end
    end

    class SomeDispatcher
      include EventStore::Messaging::Dispatcher

      handler Fixtures::SomeHandler
    end

    def self.stream_entry_data
      Fixtures.stream_entry_data.merge type: 'SomeUnknownMessage'
    end

    def self.stream_entry
      EventStore::Client::HTTP::Stream::Entry.build stream_entry_data
    end
  end
end
