require_relative 'spec_init'

describe "Deserialize Metadata" do
  event_data = EventStore::Messaging::Controls::EventData::Read.example

  msg = Fixtures::SomeDispatcher.deserialize event_data

  event_data_metadata = event_data.metadata
  msg_metadata = msg.metadata

  specify "Event ID" do
    assert(msg_metadata.event_id == event_data_metadata[:event_id])
  end

  specify "Source Stream Name" do
    assert(msg_metadata.source_stream_name == event_data_metadata[:source_stream_name])
  end

  specify "Causation Event ID" do
    assert(msg_metadata.causation_event_id == event_data_metadata[:causation_event_id])
  end

  specify "Causation Stream Name" do
    assert(msg_metadata.causation_stream_name == event_data_metadata[:causation_stream_name])
  end

  specify "Correlation Stream Name" do
    assert(msg_metadata.correlation_stream_name == event_data_metadata[:correlation_stream_name])
  end

  specify "Reply Stream Name" do
    assert(msg_metadata.reply_stream_name == event_data_metadata[:reply_stream_name])
  end
end
