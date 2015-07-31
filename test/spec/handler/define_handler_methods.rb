require_relative 'handler_init'

describe "Handler Macro" do
  handler = EventStore::Messaging::Controls::Handler.example

  it "Defines handler methods" do
    assert(handler.respond_to? :handle_some_message)
  end

  it "Registers message classes" do
    handler.class.message_registry.registered? EventStore::Messaging::Controls::Message::SomeMessage
  end
end
