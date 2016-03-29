require_relative 'client_integration_init'

context "Read a Stream" do
  stream_name = EventStore::Messaging::Controls::Writer.write 2, 'testMessageReader'

  dispatcher = EventStore::Messaging::Controls::Dispatcher.unique
  dispatcher.register_handler EventStore::Messaging::Controls::Handler::SomeHandler

  reader = EventStore::Messaging::Reader.build stream_name, dispatcher, slice_size: 1

  results = []
  reader.start do |message, event_data|
    record = Struct.new(:message, :event_data).new(message, event_data)
    results << record
  end

  results.each do |result|
    __logger.data result.message.inspect
    __logger.data result.event_data.inspect
  end

  test "Messages are read" do
    assert(results.length == 2)
  end
end
