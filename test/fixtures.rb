module Fixtures
  class SomeMessage
    include Messaging::Message

    attribute :handlers, Array, default: [], lazy: true

    def handler?(handler_name)
      handlers.any? { |name| name.end_with? handler_name }
    end
  end

  class AnotherMessage < SomeMessage
  end

  class SomeHandler
    include Messaging::Handler

    handle SomeMessage do |message|
      message.handlers << self.class.name
    end
  end

  class OtherHandler < SomeHandler
  end

  class AnotherHandler
    include Messaging::Handler

    handle AnotherMessage do |message|
      message.handlers << self.class.name
    end
  end

  class SomeDispatcher
    include Messaging::Dispatcher

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
end
