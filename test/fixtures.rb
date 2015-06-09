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

  class SomeMessage
    include EventStore::Messaging::Message

    attribute :some_attribute
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

    handle SomeEvent do |message, metadata|
      message.handlers << self.class
      metadata.data[:some_side_effect] = :effected
    end
  end

  class AnotherHandler
    include EventStore::Messaging::Handler

    handle AnotherMessage do |message|
      message.handlers << self.class
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

  def self.reader
    EventStore::Messaging::Stream::Reader::Substitute.build
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
      }
    }
  end

  def self.stream_entry
    EventStore::Stream::Entry.build stream_entry_data
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
      EventStore::Stream::Entry.build stream_entry_data
    end
  end
end
