require_relative 'spec_init'

describe "Writer Substitute" do
  context "Records writes" do
    substitute_writer = EventStore::Messaging::Writer::Substitute.build

    message = EventStore::Messaging::Controls::Message.example

    stream_name = 'some stream name'

    substitute_writer.write message, stream_name

    context "Records telemetry about the write" do
      specify "No block arguments" do
        assert(substitute_writer.written?)
      end

      specify "Message block argument only" do
        assert(substitute_writer.written? { |msg| msg == message })
      end

      specify "Message and stream name block arguments" do
        assert(substitute_writer.written? { |msg, stream| stream == stream_name })
      end
    end

    context "Records the data written" do
      specify "No block arguments" do
        assert(substitute_writer.writes.length == 1)
      end

      specify "Message block argument only" do
        assert(substitute_writer.writes { |msg| msg == message }.length == 1 )
      end

      specify "Message and stream name block arguments" do
        assert(substitute_writer.writes { |msg, stream| stream == stream_name }.length == 1)
      end
    end
  end

  ## detector calls without block args

  # context "Records replies" do
  #   substitute_writer = EventStore::Messaging::Writer::Substitute.build

  #   message = EventStore::Messaging::Controls::Message.example

  #   stream_name = message.metadata.reply_stream_name

  #   substitute_writer.reply message

  #   context "Records replied telemetry" do
  #     specify "Message argument only" do
  #       assert(substitute_writer.written? { |msg| msg == message })
  #     end

  #     specify "Message and stream name arguments" do
  #       assert(substitute_writer.written? { |msg, stream| stream == stream_name })
  #     end
  #   end
  # end
end
