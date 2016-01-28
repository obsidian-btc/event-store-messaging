require_relative 'handler_init'

context "Handle Message" do
  test "Handles" do
    handler = EventStore::Messaging::Controls::Handler::HandlesHandledMessage.new
    message = EventStore::Messaging::Controls::Message::HandledMessage.new

    handler.handle message

    assert(message.handler? "HandlesHandledMessage")
  end
end
