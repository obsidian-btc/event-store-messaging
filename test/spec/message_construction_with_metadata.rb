require_relative 'spec_init'

describe "Message Construction with Metadata" do
  previous_metadata = Fixtures::Metadata.metadata

  describe "Linked message copies metadata" do
    msg = Fixtures::SomeMessage.linked previous_metadata

    metadata = msg.metadata

    specify "Sets the causation event ID to the previous event ID" do
      assert(metadata.causation_event_id == previous_metadata.event_id)
    end

    specify "Sets the causation stream name to the previous source stream name" do
      assert(metadata.causation_stream_name == previous_metadata.source_stream_name)
    end

    specify "Sets the correlation stream name to the previous correlation stream name" do
      assert(metadata.correlation_stream_name == previous_metadata.correlation_stream_name)
    end

    specify "Sets the reply stream name to the previous reply stream name" do
      assert(metadata.reply_stream_name == previous_metadata.reply_stream_name)
    end

    specify "Does not copy the event ID to the previous event ID" do
      refute(metadata.event_id == previous_metadata.event_id)
    end

    specify "Does not copy the source stream name" do
      assert(metadata.source_stream_name.nil?)
    end
  end

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
