require_relative 'client_integration_init'

describe "Read a Stream" do
  stream_name = EventStore::Messaging::Controls::StreamName.get 'testStreamNotFound'

  dispatcher = EventStore::Messaging::Controls::Dispatcher::BasicDispatcher.new
  dispatcher.register_handler EventStore::Messaging::Controls::Handler::SomeHandler

  reader = EventStore::Messaging::Reader.build stream_name, dispatcher

  enumerated = false
  reader.start do |message, event_data|
    enumerated = true
  end

  specify "Messages are not enumerated" do
    refute(enumerated)
  end
end
