require_relative 'data_interchange_init.rb'

context "Import Event Data to Message" do
  event_data = EventStore::Messaging::Controls::EventData::Read.example

  message_class = EventStore::Messaging::Controls::Message.message_class

  message = EventStore::Messaging::Message::Import::EventData.(event_data, message_class)

  test "Message type is the event data type" do
    assert(message.class.message_type == event_data.type)
  end

  context "Message data is the event data" do
    test "Some Attribute" do
      assert(message.some_attribute == event_data.data[:some_attribute])
    end

    test "Some Time" do
      assert(message.some_time == event_data.data[:some_time])
    end
  end

  context "Message metadata is the event metadata" do
    metadata = message.metadata

    test "Source Event URI" do
      assert(metadata.causation_event_uri == event_data.metadata[:causation_event_uri])
    end

    test "Causation Event URI" do
      assert(metadata.causation_event_uri == event_data.metadata[:causation_event_uri])
    end

    test "Correlation Stream Name" do
      assert(metadata.correlation_stream_name == event_data.metadata[:correlation_stream_name])
    end

    test "Reply Stream Name" do
      assert(metadata.reply_stream_name == event_data.metadata[:reply_stream_name])
    end

    test "Schema Version" do
      assert(metadata.schema_version == event_data.metadata[:schema_version])
    end
  end
end
