require_relative 'client_integration_init'

context "Read a Stream" do
  stream_name = EventStore::Messaging::Controls::StreamName.get 'testStreamNotFound'

  dispatcher = EventStore::Messaging::Controls::Dispatcher.unique
  dispatcher.register_handler EventStore::Messaging::Controls::Handler::SomeHandler

  reader = EventStore::Messaging::Reader.build stream_name, dispatcher

  enumerated = false
  reader.start do |message, event_data|
    enumerated = true
  end

  test "Messages are not enumerated" do
    assert(!enumerated)
  end
end
