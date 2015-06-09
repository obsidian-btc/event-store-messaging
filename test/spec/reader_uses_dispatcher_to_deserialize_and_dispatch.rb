require_relative 'spec_init'

describe "Stream Subscription" do
  specify "Read data from stream and dispatches it as a message and the original data represented as a stream entry" do
    dispatcher = Fixtures::SingleDispatcher.new
    stream_entry = Fixtures.stream_entry

    reader = EventStore::Messaging::Stream::Reader.new
    reader.dispatcher = dispatcher

    message = reader.read(stream_entry)

    assert(message.handled?)
    assert(message.handler? Fixtures::SomeHandler.name)
  end

  specify "Data for an unknown message type is not dispatched" do
    dispatcher = Fixtures.dispatcher
    stream_entry = Fixtures::Anomalies.stream_entry

    reader = EventStore::Messaging::Stream::Reader.new
    reader.dispatcher = dispatcher

    message = reader.read(stream_entry)

    assert(message.nil?)
  end
end
