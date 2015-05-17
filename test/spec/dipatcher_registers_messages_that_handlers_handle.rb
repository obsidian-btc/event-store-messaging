require_relative 'spec_init'

describe "Dispatcher" do
  it "Registers classes of messages that its handlers handle" do
    dispatcher = Fixtures.dispatcher

    message_classes = dispatcher.class.message_classes

    assert(message_classes.include? Fixtures::SomeMessage)
    assert(message_classes.include? Fixtures::AnotherMessage)
    assert(message_classes.length == 2)
  end
end
