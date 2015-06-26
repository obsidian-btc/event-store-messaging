require_relative 'spec_init'

describe "Metadata Builder" do
  event_id = UUID.random

  source_stream_id = UUID.random
  source_stream = "sourceStream-#{source_stream_id}"

  correlation_stream_id = UUID.random
  correlation_stream = "correlationStream-#{correlation_stream_id}"

  causation_event_id = UUID.random
  causation_stream_id = UUID.random
  causation_stream = "causationStream-#{causation_stream_id}"

  reply_stream_id = UUID.random
  reply_stream = "replyStream-#{reply_stream_id}"

  previous_metadata = EventStore::Messaging::Message::Metadata.new

  previous_metadata.event_id = event_id
  previous_metadata.source_stream = source_stream
  previous_metadata.correlation_stream = correlation_stream
  previous_metadata.causation_event_id = causation_event_id
  previous_metadata.causation_stream = causation_stream
  previous_metadata.reply_stream = reply_stream

  builder = EventStore::Messaging::Message::Metadata::Builder.new

    # builder.no_reply
    # builder.initiate(source_stream)


  describe "Copying Metadata" do
    builder.set(previous_metadata)

    metadata = builder.get

    specify "Copies stream data from another metadata instance" do
      assert(metadata.source_stream == source_stream)
      assert(metadata.correlation_stream == correlation_stream)
      assert(metadata.causation_event_id == causation_event_id)
      assert(metadata.causation_stream == causation_stream)
      assert(metadata.reply_stream == reply_stream)
    end

    specify "Does not copy the ID from another metadata instance" do
      refute(metadata.event_id == event_id)
    end
  end

  describe "Initiating an Event Stream" do
    builder.set(previous_metadata)

    initiated_stream_id = UUID.random
    initiated_stream = "initiatedStream-#{initiated_stream_id}"

    builder.initiate_stream(initiated_stream)

    metadata = builder.get

    specify "Clears all data except for the correlation stream" do
      assert(metadata.source_stream.nil?)
      assert(metadata.causation_event_id.nil?)
      assert(metadata.causation_stream.nil?)
      assert(metadata.reply_stream.nil?)
    end

    specify "Sets the correlation stream to the new stream name" do
      assert(metadata.correlation_stream == initiated_stream)
    end
  end
end
