require_relative 'spec_init'

describe "Deserialize Stream Entry Metadata" do
  stream_entry = Fixtures.stream_entry
  msg = Fixtures::SomeDispatcher.deserialize stream_entry

  msg_metadata = msg.metadata
  se_metadata = stream_entry.metadata

  specify "Event ID" do
    assert(msg_metadata.event_id == se_metadata[:event_id])
  end

  specify "Source Stream Name" do
    assert(msg_metadata.source_stream_name == se_metadata[:source_stream_name])
  end

  specify "Causation Event ID" do
    assert(msg_metadata.causation_event_id == se_metadata[:causation_event_id])
  end

  specify "Causation Stream Name" do
    assert(msg_metadata.causation_stream_name == se_metadata[:causation_stream_name])
  end

  specify "Correlation Stream Name" do
    assert(msg_metadata.correlation_stream_name == se_metadata[:correlation_stream_name])
  end

  specify "Reply Stream Name" do
    assert(msg_metadata.reply_stream_name == se_metadata[:reply_stream_name])
  end
end
