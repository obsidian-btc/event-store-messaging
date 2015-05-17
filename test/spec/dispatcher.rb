require_relative 'spec_init'

describe "Dispatcher" do
  it "Dispatchers messages to handlers that can handle it" do
    dispatcher = Fixtures.dispatcher
    message = Fixtures.message

    dispatcher.dispatch message

    refute(message.handlers.empty?)
  end

  it "Detects handlers that it can dispatch a message to" do
    dispatcher = Fixtures.dispatcher
    message = Fixtures.message

    handler_classes = dispatcher.handles(message)

    names = handler_classes.map do |handler_class|
      handler_class.name.split('::').last
    end

    assert(names.include? 'SomeHandler')
    assert(names.include? 'OtherHandler')
    refute(names.include? 'AnotherHandler')
  end

  it "Registers classes of messages that its handlers handle" do
    dispatcher = Fixtures.dispatcher

    message_classes = dispatcher.class.message_classes

    assert(message_classes.include? Fixtures::SomeMessage)
    assert(message_classes.include? Fixtures::AnotherMessage)
    assert(message_classes.length == 2)
  end
end
