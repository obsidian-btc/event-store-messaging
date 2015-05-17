require_relative 'spec_init'

describe "Dispatcher" do
  it "Registers classes of messages that its handlers handle" do
    dispatcher = Fixtures.dispatcher

    message_registry = dispatcher.class.message_registry

    assert(message_registry.registered? Fixtures::SomeMessage)
    assert(message_registry.registered? Fixtures::AnotherMessage)
    assert(message_registry.length == 2)
  end
end
