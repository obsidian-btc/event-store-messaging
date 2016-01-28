require_relative 'dispatcher_init'

context "Dispatch a Message" do
  test "Dispatches to handler that handles the message" do
    dispatcher = EventStore::Messaging::Controls::Dispatcher::DispatcherHandlesHandledMessage.new
    message = EventStore::Messaging::Controls::Message::HandledMessage.new
    event_data = EventStore::Messaging::Controls::EventData::Read.example

    dispatcher.dispatch message, event_data

    assert(message.handler? 'HandlesHandledMessage')
    assert(!(message.handler? 'SomeHandler'))

    assert(message.handlers.length == 1)
  end
end
