require_relative 'spec_init'

describe "Stream Subscription" do
  specify "Read data from stream and dispatches it as a message and the original data represented as a stream item" do
    dispatcher = Fixtures::SingleDispatcher.new
    item_data = Fixtures.stream_item_data

    reader = EventStore::Messaging::Stream::Reader.new
    reader.dispatcher = dispatcher

    message, stream_item = reader.read(item_data)

    assert(message.handled?)
    assert(message.handler? Fixtures::SomeHandler.name)
  end

  specify "Data for an unknown message type is not dispatched" do
    dispatcher = Fixtures.dispatcher
    item_data = Fixtures::Anomalies.stream_item_data

    reader = EventStore::Messaging::Stream::Reader.new
    reader.dispatcher = dispatcher

    message, stream_item = reader.read(item_data)

    assert(message.nil?)
  end
end
