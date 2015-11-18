require_relative 'message_init'

describe "Message Precedence" do
  let(:source_message) { EventStore::Messaging::Controls::Message.example }
  let(:msg) { EventStore::Messaging::Controls::Message.message_class.new }

  context "Messages have precedence" do
    specify "When their metadata have precedence" do
      msg.metadata.causation_event_uri = source_message.metadata.source_event_uri
      msg.metadata.correlation_stream_name = source_message.metadata.correlation_stream_name
      msg.metadata.reply_stream_name = source_message.metadata.reply_stream_name

      assert(msg.precedence?(source_message))
    end
  end
end
