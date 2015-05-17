require_relative 'spec_init'

describe "Dispatcher" do
  it "Registers classes of messages that its handlers handle" do
    dispatcher = Fixtures.dispatcher

    message_registry = dispatcher.class.message_registry

    assert(message_registry.registered? Fixtures::SomeMessage)
    assert(message_registry.registered? Fixtures::AnotherMessage)
    assert(message_registry.length == 2)
  end

  it "Registers classes of messages that its handlers handle" do
    dispatcher_class = Fixtures::Anomalies::SomeDispatcher

    dispatcher_class.handler Fixtures::SomeHandler

    handler_classes = dispatcher_class.handler_classes

    assert(handler_classes.registered? Fixtures::SomeHandler)
    assert(handler_classes.length == 1)
  end
end
