require_relative '../message_init'

describe "Proceed from Previous Message from a Class" do
  let(:source) { EventStore::Messaging::Controls::Message.example }

  let(:source_metadata) { source.metadata }
  let(:metadata) { msg.metadata }

  let(:msg) { EventStore::Messaging::Controls::Message.message_class.proceed(source) }

  specify "Constructs the class" do
    assert(msg.class == source.class)
  end

  context "Copied metadata attributes" do
    specify "Copies the causation event URI" do
      assert(metadata.causation_event_uri == source_metadata.source_event_uri)
    end

    specify "Copies the correlation stream name" do
      assert(metadata.correlation_stream_name == source_metadata.correlation_stream_name)
    end

    specify "Copies the reply stream name" do
      assert(metadata.reply_stream_name == source_metadata.reply_stream_name)
    end
  end

  context "Metadata attributes not copied" do
    specify "Does not copy the source event URI" do
      assert(metadata.source_event_uri.nil?)
    end

    specify "Does not copy the schema version" do
      assert(metadata.schema_version.nil?)
    end
  end
end
