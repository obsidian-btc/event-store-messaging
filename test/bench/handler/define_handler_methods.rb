require_relative 'handler_init'

context "Handler Macro" do
  handler = EventStore::Messaging::Controls::Handler.example

  test "Defines handler methods" do
    assert(handler.respond_to? :handle_some_message)
  end

  test "Registers message classes" do
    handler.class.message_registry.registered? EventStore::Messaging::Controls::Message::SomeMessage
  end
end
