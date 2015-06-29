require_relative 'spec_init'

describe "Convert message to event data" do
  message = Fixtures.some_message_with_metadata
  message.some_attribute = 'some value'
  event_data = EventStore::Messaging::Message::Conversion::EventData.! message

  specify "An ID is assigned to the event data" do
    refute(event_data.id.nil?)
  end

  specify "The event data type is the message type" do
    assert(event_data.type == 'SomeMessage')
  end

  specify "Data is converted" do
    entry_data = {
      some_attribute: "some value"
    }

    assert(event_data.data == entry_data)
  end

  specify "Metadata is converted" do
    metadata = message.metadata

    compare_data = {
      source_stream_name: metadata.source_stream_name,
      correlation_stream_name: metadata.correlation_stream_name,
      causation_event_id: metadata.causation_event_id,
      causation_stream_name: metadata.causation_stream_name,
      reply_stream_name: metadata.reply_stream_name,
      version: metadata.version
    }

    assert(event_data.metadata == compare_data)
  end
end

describe "Metadata with empty fields" do
  specify "Is excluded" do
    message = Fixtures.some_message
    message.some_attribute = 'some value'
    event_data = EventStore::Messaging::Message::Conversion::EventData.! message

    metadata = message.metadata

    compare_data = {
    }

    assert(event_data.metadata == compare_data)
  end
end
