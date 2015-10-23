require_relative 'data_interchange_init.rb'

describe "Import Event Data to Message" do
  event_data = EventStore::Messaging::Controls::EventData::Read.example(omit_metadata: true)

  message_class = EventStore::Messaging::Controls::Message.message_class

  message = EventStore::Messaging::Message::Import::EventData.(event_data, message_class)

  describe "Message without source metadata has metadata with nil values" do
    metadata = message.metadata

    specify "Source Event URI" do
      assert(metadata.causation_event_uri.nil?)
    end

    specify "Causation Event URI" do
      assert(metadata.causation_event_uri.nil?)
    end

    specify "Correlation Stream Name" do
      assert(metadata.correlation_stream_name.nil?)
    end

    specify "Reply Stream Name" do
      assert(metadata.reply_stream_name.nil?)
    end

    specify "Schema Version" do
      assert(metadata.schema_version.nil?)
    end
  end
end
