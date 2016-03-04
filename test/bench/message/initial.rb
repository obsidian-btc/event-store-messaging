require_relative 'message_init'

context "Initial message in a stream" do
  previous_metadata = EventStore::Messaging::Controls::Message::Metadata.example

  initiated_stream_name = EventStore::Messaging::Controls::Message::Metadata.initial_stream_name

  message = EventStore::Messaging::Controls::Message::SomeMessage.initial initiated_stream_name

  metadata = message.metadata

  test "Constructs the message" do
    assert(message.class == EventStore::Messaging::Controls::Message::SomeMessage)
  end

  test "Sets the correlation stream to the new stream name" do
    assert(metadata.correlation_stream_name == initiated_stream_name)
  end

  test "Leaves the reset of the metadata empty" do
    assert(metadata.source_event_uri.nil?)
    assert(metadata.causation_event_uri.nil?)
    assert(metadata.reply_stream_name.nil?)
    assert(metadata.schema_version.nil?)
  end
end
