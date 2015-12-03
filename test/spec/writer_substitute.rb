require_relative 'spec_init'

describe "Writer Substitute" do
  context "Records writes" do
    substitute_writer = EventStore::Messaging::Writer::Substitute.build

    message = EventStore::Messaging::Controls::Message.example

    stream_name = 'some stream name'

    substitute_writer.write message, stream_name

    specify "Records telemetry about the write" do
      assert(substitute_writer.written? { |msg| msg == message })
    end
  end

#   context "Reply" do
#     message = EventStore::Messaging::Controls::Message.example

#     substitute_writer = EventStore::Messaging::Writer.build

#     sink = EventStore::Messaging::Writer.register_telemetry_sink(substitute_writer)

#     substitute_writer.reply message

#     specify "Records replied telemetry" do
#       assert(sink.recorded_replied?)
#     end
#   end
end
