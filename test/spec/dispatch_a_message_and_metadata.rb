require_relative 'spec_init'

describe "Dispatcher" do
  it "Dispatchers messages and metadata if the handler receives the metadata" do
    dispatcher = Fixtures.dispatcher
    message = Fixtures.message
    stream_item = Fixtures.stream_item

    dispatcher.dispatch message, stream_item

    assert(stream_item.data[:some_side_effect])
  end
end
