require_relative 'spec_init'

describe "Dispatcher" do
  it "Dispatchers messages to handlers that can handle it" do
    dispatcher = Fixtures.dispatcher
    message = Fixtures.message

    dispatcher.dispatch message

    assert(message.handlers.include? "Fixtures::SomeHandler")
    assert(message.handlers.include? "Fixtures::OtherHandler")
    assert(message.handlers.length == 2)
  end
end
