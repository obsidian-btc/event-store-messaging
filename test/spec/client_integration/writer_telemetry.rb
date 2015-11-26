require_relative './client_integration_init'

describe "Writer Telemetry" do
  context "Write" do
    message = EventStore::Messaging::Controls::Message.example
    writer = EventStore::Messaging::Writer.build
    stream_name = EventStore::Messaging::Controls::StreamName.get 'testWriter'

    sink = EventStore::Messaging::Controls::Writer::Telemetry::Sink.example
    writer.telemetry.register sink

    writer.write message, stream_name

    specify "Records written telemetry" do
      refute(sink.written_records.empty?)
    end
  end

  context "Reply" do
    message = EventStore::Messaging::Controls::Message.example

    writer = EventStore::Messaging::Writer.build

    sink = EventStore::Messaging::Controls::Writer::Telemetry::Sink.example
    writer.telemetry.register sink

    writer.reply message

    specify "Records replied telemetry" do
      refute(sink.replied_records.empty?)
    end
  end
end
