require_relative 'spec_init'

describe "Stream Reader" do
  it "Read data from stream and dispatches it" do
    dispatcher = Fixtures::SingleDispatcher.new
    item_data = Fixtures.stream_item_data

    reader = EventStore::Messaging::Stream::Reader.new
    reader.dispatcher = dispatcher

    message, stream_item = reader.read(item_data)

    assert(message.handler? Fixtures::SomeHandler.name)
    assert(message.handled?)
  end
end

describe "Read data for an unknown message type" do
  specify "Is an error" do
    dispatcher = Fixtures.dispatcher
    item_data = Fixtures::Anomalies.stream_item_data

    reader = EventStore::Messaging::Stream::Reader.new
    reader.dispatcher = dispatcher

    assert_raises EventStore::Messaging::Stream::Reader::Error do
      reader.read(item_data)
    end
  end
end
