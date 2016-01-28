require_relative 'dispatcher_init'

context "Dispatcher" do
  test "Dispatchers messages and event data if the handler receives the event data" do
    dispatcher = EventStore::Messaging::Controls::Dispatcher::DispatcherChangesEventData.new
    message = EventStore::Messaging::Controls::Message.example
    event_data = EventStore::Messaging::Controls::EventData::Read.example

    dispatcher.dispatch message, event_data

    assert(event_data.data[:some_side_effect] == 1)
  end
end
