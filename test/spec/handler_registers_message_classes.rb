require_relative 'spec_init'

describe "Handler" do
  it "Registers classes of messages that it handles" do
    handler = Fixtures.handler

    message_classes = handler.class.message_classes

    assert(message_classes.registered? Fixtures::SomeMessage)
  end

  it "Registers message classes once only" do
    handler_class = Fixtures::Anomalies::SomeHandler

    handler_class.handle Fixtures::SomeMessage do
      puts "Handling the same message is not allowed"
    end

    message_classes = handler_class.message_classes

    assert(message_classes.registered? Fixtures::SomeMessage)
    assert(message_classes.length == 1)
  end
end
