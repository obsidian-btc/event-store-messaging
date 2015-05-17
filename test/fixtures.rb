module Fixtures
  class SomeMessage
    include EventStore::Messaging::Message

    attribute :some_attribute

    attribute :handlers, Array, default: [], lazy: true

    def handler?(handler_name)
      handlers.any? { |name| name.end_with? handler_name }
    end
  end

  class AnotherMessage < SomeMessage
  end

  class SomeHandler
    include EventStore::Messaging::Handler

    handle SomeMessage do |message|
      message.handlers << self.class.name
    end
  end

  class OtherHandler
    include EventStore::Messaging::Handler

    handle SomeMessage do |message|
      message.handlers << self.class.name
    end
  end

  class AnotherHandler
    include EventStore::Messaging::Handler

    handle AnotherMessage do |message|
      message.handlers << self.class.name
    end
  end

  class SomeDispatcher
    include EventStore::Messaging::Dispatcher

    handler SomeHandler
    handler OtherHandler
    handler AnotherHandler
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

  module Anomalies
    class HandlerWithDuplicateBlocks
      include EventStore::Messaging::Handler

      handle SomeMessage do |message|
        message.handlers << self.class.name
      end

      handle SomeMessage do |message|
        raise "Duplicate handler of #{message.class.name}"
      end
    end
  end
end
