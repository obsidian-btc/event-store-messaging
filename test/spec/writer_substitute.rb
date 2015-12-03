require_relative 'spec_init'

describe "Writer Substitute" do
  context "Records writes" do
    substitute_writer = EventStore::Messaging::Writer::Substitute.build

    message = EventStore::Messaging::Controls::Message.example

    stream_name = 'some stream name'

    substitute_writer.write message, stream_name

    context "Records telemetry about the write" do
      specify "Message argument only" do
        assert(substitute_writer.written? { |msg| msg == message })
      end

      specify "Message and stream name arguments" do
        assert(substitute_writer.written? { |msg, stream| stream == stream_name })
      end
    end
  end

  context "Records replies" do
    substitute_writer = EventStore::Messaging::Writer::Substitute.build

    message = EventStore::Messaging::Controls::Message.example

    stream_name = message.metadata.reply_stream_name

    substitute_writer.reply message

    context "Records replied telemetry" do
      specify "Message argument only" do
        assert(substitute_writer.written? { |msg| msg == message })
      end

      specify "Message and stream name arguments" do
        assert(substitute_writer.written? { |msg, stream| stream == stream_name })
      end
    end
  end
end
