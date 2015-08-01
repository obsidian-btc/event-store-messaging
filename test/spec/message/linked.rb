require_relative 'message_init'

describe "Linked message copies metadata" do
  previous_metadata = EventStore::Messaging::Controls::Message::Metadata.example
  message = EventStore::Messaging::Controls::Message::SomeMessage.linked previous_metadata

  metadata = message.metadata

  specify "Constructs the message" do
    assert(message.class == EventStore::Messaging::Controls::Message::SomeMessage)
  end

  specify "Sets the causation event URI to the previous source event URI" do
    assert(metadata.causation_event_uri == previous_metadata.source_event_uri)
  end

  specify "Sets the correlation stream name to the previous correlation stream name" do
    assert(metadata.correlation_stream_name == previous_metadata.correlation_stream_name)
  end

  specify "Sets the reply stream name to the previous reply stream name" do
    assert(metadata.reply_stream_name == previous_metadata.reply_stream_name)
  end

  specify "Does not set the source event URI" do
    assert(metadata.source_event_uri.nil?)
  end

  specify "Does not set the schema version" do
    assert(metadata.schema_version.nil?)
  end
end
