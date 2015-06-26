require_relative 'spec_init'

# causation stream is the source stream of previous event
# reply stream is set in the writer.write method

describe "Metadata Builder" do
  event_id = UUID.random

  source_stream_id = UUID.random
  source_stream_name = "sourceStream-#{source_stream_id}"

  correlation_stream_id = UUID.random
  correlation_stream_name = "correlationStream-#{correlation_stream_id}"

  causation_event_id = UUID.random
  causation_stream_id = UUID.random
  causation_stream_name = "causationStream-#{causation_stream_id}"

  reply_stream_id = UUID.random
  reply_stream_name = "replyStream-#{reply_stream_id}"

  previous_metadata = EventStore::Messaging::Message::Metadata.new

  previous_metadata.event_id = event_id
  previous_metadata.source_stream_name = source_stream_name
  previous_metadata.correlation_stream_name = correlation_stream_name
  previous_metadata.causation_event_id = causation_event_id
  previous_metadata.causation_stream_name = causation_stream_name
  previous_metadata.reply_stream_name = reply_stream_name

  builder = EventStore::Messaging::Message::Metadata::Builder.new

    # builder.no_reply
    # builder.initiate(source_stream_name)


  describe "Copying Metadata" do
    builder.set(previous_metadata)

    metadata = builder.get

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

    specify "Does not set the event ID to the previous event ID" do
      refute(metadata.event_id == event_id)
    end

    specify "Does not set the source stream name" do
      assert(metadata.source_stream_name.nil?)
    end
  end

  describe "Initiating an Event Stream" do
    builder.set(previous_metadata)

    initiated_stream_id = UUID.random
    initiated_stream = "initiatedStream-#{initiated_stream_id}"

    builder.initiate_stream(initiated_stream)

    metadata = builder.get

    specify "Clears all data except for the correlation stream" do
      assert(metadata.source_stream_name.nil?)
      assert(metadata.causation_event_id.nil?)
      assert(metadata.causation_stream_name.nil?)
      assert(metadata.reply_stream_name.nil?)
    end

    specify "Sets the correlation stream to the new stream name" do
      assert(metadata.correlation_stream_name == initiated_stream)
    end
  end
end
