require_relative 'dispatcher_init'

context "Dispatch a Message That the Handler Doesn't Handle" do
  test "Does not handle the message" do
    dispatcher = EventStore::Messaging::Controls::Dispatcher::SomeDispatcher.new
    message = EventStore::Messaging::Controls::Message::HandledMessage.new
    event_data = EventStore::Messaging::Controls::EventData::Read.example

    dispatcher.dispatch message, event_data

    assert(message.handlers.length == 0)
  end
end
