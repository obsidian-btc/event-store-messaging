require_relative 'client_integration_init'

describe "Reader a Stream's Events" do
  stream_name = EventStore::Messaging::Controls::Writer.write 2, 'testMessageReader'

  dispatcher = EventStore::Messaging::Controls::Dispatcher::BasicDispatcher.new
  dispatcher.register_handler EventStore::Messaging::Controls::Handler::SomeHandler

  reader = EventStore::Messaging::Reader.build stream_name, dispatcher, slice_size: 1

  messages = []
  reader.read do |message|
    messages << message
  end

  messages.each do |message|
    logger(__FILE__).data message.inspect
  end

  specify "Messages are read" do
    assert(messages.length == 2)
  end
end
