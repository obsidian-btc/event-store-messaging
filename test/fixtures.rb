module Fixtures
  class SomeMessage
    include EventStore::Messaging::Message

    attribute :some_attribute

    attribute :handlers, Array, default: [], lazy: true

    def handler?(handler_name)
      handlers.any? { |handler_class| handler_class.name.end_with? handler_name }
    end
  end

  class AnotherMessage < SomeMessage
  end

  class SomeHandler
    include EventStore::Messaging::Handler

    handle SomeMessage do |message|
      message.handlers << self.class
    end
  end

  class OtherHandler
    include EventStore::Messaging::Handler

    handle SomeMessage do |message, metadata|
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

  class SomeRegistry
    include EventStore::Messaging::Registry
  end

  def self.dispatcher
    SomeDispatcher.new
  end

  def self.handler
    SomeHandler.new
  end

  def self.message
    SomeMessage.new
  end

  def self.registry
    SomeRegistry.new
  end

  def self.stream_item_data
    {
      id: '10000000-0000-0000-0000-000000000000',
      type: 'SomeMessage',
      version: 1,
      stream_name: 'SomeStream',
      data: {
        some_attribute: 'some value'
      }
    }
  end

  def self.stream_item
    EventStore::Messaging::Stream::Item.build stream_item_data
  end

  module Anomalies
    class SomeHandler
      include EventStore::Messaging::Handler

      handle SomeMessage do |message|
        message.handlers << self.class.name
      end
    end

    class SomeDispatcher
      include EventStore::Messaging::Dispatcher

      handler Fixtures::SomeHandler
    end

    def self.stream_item_data
      Fixtures.stream_item_data.merge type: 'SomeUnknownMessage'
    end
  end
end
