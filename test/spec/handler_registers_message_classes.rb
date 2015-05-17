require_relative 'spec_init'

describe "Handler" do
  it "Registers classes of messages that it handles" do
    handler = Fixtures.handler

    message_classes = handler.class.message_classes

    assert(message_classes.registered? Fixtures::SomeMessage)
  end
end
