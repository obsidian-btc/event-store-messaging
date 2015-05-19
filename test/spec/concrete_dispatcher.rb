require_relative 'spec_init'

describe "Dispatcher" do
  it "Dispatchers messages to handlers that can handle it" do
    dispatcher = EventStore::Messaging::Dispatcher::Concrete.new
    dispatcher.handlers.register Fixtures.handler.class

    message = Fixtures.message
    stream_item = Fixtures.stream_item

    dispatcher.dispatch message, stream_item

    refute(message.handlers.empty?)
  end
end
