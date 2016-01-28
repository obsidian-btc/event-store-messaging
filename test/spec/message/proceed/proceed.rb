require_relative '../message_init'

context "Proceed from Previous Message" do
  source = EventStore::Messaging::Controls::Message.example
  msg = source.class.new

  EventStore::Messaging::Message::Proceed.(source, msg)

  source_metadata = source.metadata
  metadata = msg.metadata

  context "Copied metadata attributes" do
    test "Copies the causation event URI" do
      assert(metadata.causation_event_uri == source_metadata.source_event_uri)
    end

    test "Copies the correlation stream name" do
      assert(metadata.correlation_stream_name == source_metadata.correlation_stream_name)
    end

    test "Copies the reply stream name" do
      assert(metadata.reply_stream_name == source_metadata.reply_stream_name)
    end
  end

  context "Metadata attributes not copied" do
    test "Does not copy the source event URI" do
      assert(metadata.source_event_uri.nil?)
    end

    test "Does not copy the schema version" do
      assert(metadata.schema_version.nil?)
    end
  end
end
