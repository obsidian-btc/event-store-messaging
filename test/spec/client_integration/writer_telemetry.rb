require_relative './client_integration_init'

describe "Writer Telemetry" do
  context "Write" do
    message = EventStore::Messaging::Controls::Message.example
    writer = EventStore::Messaging::Writer.build
    stream_name = EventStore::Messaging::Controls::StreamName.get 'testWriter'

    sink = EventStore::Messaging::Writer::Telemetry.sink
    writer.telemetry.register sink

    writer.write message, stream_name

    specify "Records written telemetry" do
      assert(sink.recorded_written?)
    end
  end

  context "Reply" do
    message = EventStore::Messaging::Controls::Message.example

    writer = EventStore::Messaging::Writer.build

    sink = EventStore::Messaging::Writer::Telemetry.sink
    writer.telemetry.register sink

    writer.reply message

    specify "Records replied telemetry" do
      assert(sink.recorded_replied?)
    end
  end
end
