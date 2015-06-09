require_relative 'spec_init'

describe "Dispatcher" do
  it "Dispatchers messages and stream entry if the handler receives the stream entry" do
    dispatcher = Fixtures.dispatcher
    message = Fixtures.message
    stream_entry = Fixtures.stream_entry

    dispatcher.dispatch message, stream_entry

    assert(stream_entry.data[:some_side_effect])
  end
end
