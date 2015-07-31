require_relative 'handler_init'

describe "Handler" do
  it "Registers classes of messages that it handles" do
    handler = EventStore::Messaging::Controls::Handler.example
    message_class = EventStore::Messaging::Controls::Message.message_class

    message_registry = handler.class.message_registry

    assert(message_registry.registered? message_class)
  end
end
