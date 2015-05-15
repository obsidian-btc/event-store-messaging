require_relative 'spec_init'

describe "Handler" do
  it "Registers classes of message that they handle" do
    handler = Fixtures.handler

    message_classes = handler.class.message_classes

    assert(message_classes.include? Fixtures.message.class)
  end
end
