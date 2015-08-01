require_relative 'message_init'

describe "Message Construction with Metadata" do
  previous_metadata = Fixtures::Metadata.metadata

  describe "Initiating an Event Stream" do
    initiated_stream_name = Fixtures::Metadata.source_stream_name

    msg = Fixtures::SomeMessage.initial initiated_stream_name

    metadata = msg.metadata

    specify "Sets the correlation stream to the new stream name" do
      assert(metadata.correlation_stream_name == initiated_stream_name)
    end

    specify "Leaves the reset of the metadata empty" do
      assert(metadata.source_stream_name.nil?)
      assert(metadata.causation_event_id.nil?)
      assert(metadata.causation_stream_name.nil?)
      assert(metadata.reply_stream_name.nil?)
    end
  end
end
