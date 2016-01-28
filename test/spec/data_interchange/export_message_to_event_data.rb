require_relative 'data_interchange_init.rb'

context "Export Message to Event Data" do
  message = EventStore::Messaging::Controls::Message.example

  event_data = EventStore::Messaging::Message::Export::EventData.(message)

  test "An ID is assigned to the event data" do
    assert(!event_data.id.nil?)
  end

  test "Event data type is the message type" do
    assert(event_data.type == 'SomeMessage')
  end

  test "Event data data is the message's data" do
    compare = EventStore::Messaging::Controls::Message.data

    assert(event_data.data == compare)
  end

  test "Event data metadata is the message's metadata" do
    compare = EventStore::Messaging::Controls::Message::Metadata.data

    assert(event_data.metadata == compare)
  end
end

context "Metadata with empty fields" do
  test "Empty fields are excluded" do
    metadata = EventStore::Messaging::Controls::Message::Metadata::Empty.example

    message = EventStore::Messaging::Controls::Message.example metadata: metadata

    event_data = EventStore::Messaging::Message::Export::EventData.(message)

    metadata = message.metadata

    compare_data = {
    }

    assert(event_data.metadata == compare_data)
  end
end

