require_relative 'spec_init'

describe "Dispatcher" do
  it "Dispatchers messages to handlers that can handle it" do
    dispatcher = Fixtures.dispatcher
    message = Fixtures.message
    stream_item = Fixtures.stream_item

    dispatcher.dispatch message, stream_item

    assert(message.handler? Fixtures::SomeHandler)
    assert(message.handler? Fixtures::OtherHandler)
    assert(message.handlers.length == 2)
  end
end
