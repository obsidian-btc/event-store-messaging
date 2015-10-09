require_relative 'data_interchange_init.rb'

describe "Import Event Data to Message" do
  event_data = EventStore::Messaging::Controls::EventData::Read.example

  message_class = EventStore::Messaging::Controls::Message.message_class

  message = EventStore::Messaging::Message::Import::EventData.(event_data, message_class)

  specify "Message type is the event data type" do
    assert(message.class.message_type == event_data.type)
  end

  describe "Message data is the event data" do
    specify "Some Attribute" do
      assert(message.some_attribute == event_data.data[:some_attribute])
    end

    specify "Some Time" do
      assert(message.some_time == event_data.data[:some_time])
    end
  end

  describe "Message metadata is the event metadata" do
    metadata = message.metadata

    specify "Source Event URI" do
      assert(metadata.causation_event_uri == event_data.metadata[:causation_event_uri])
    end

    specify "Causation Event URI" do
      assert(metadata.causation_event_uri == event_data.metadata[:causation_event_uri])
    end

    specify "Correlation Stream Name" do
      assert(metadata.correlation_stream_name == event_data.metadata[:correlation_stream_name])
    end

    specify "Reply Stream Name" do
      assert(metadata.reply_stream_name == event_data.metadata[:reply_stream_name])
    end

    specify "Schema Version" do
      assert(metadata.schema_version == event_data.metadata[:schema_version])
    end
  end
end
