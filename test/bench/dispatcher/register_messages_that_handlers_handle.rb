require_relative 'dispatcher_init'

context "Dispatcher" do
  test "Registers classes of messages that its handlers handle" do
    dispatcher = EventStore::Messaging::Controls::Dispatcher.example

    message_registry = dispatcher.class.message_registry

    assert(message_registry.registered? EventStore::Messaging::Controls::Message::SomeMessage)
    assert(message_registry.registered? EventStore::Messaging::Controls::Message::AnotherMessage)
    assert(message_registry.length == 2)
  end
end
