require_relative 'handler_init'

describe "Handler" do
  handler = EventStore::Messaging::Controls::Handler.example

  it "Determine whether it handles based on a message class name" do
    message_type = "SomeMessage"
    assert(handler.class.handles? message_type)
  end

  it "Determine whether it handles based on a message object" do
    message = EventStore::Messaging::Controls::Message.example
    assert(handler.class.handles? message)
  end

  it "Determine whether it handles based on a message class" do
    message_class = EventStore::Messaging::Controls::Message.message_class
    assert(handler.class.handles? message_class)
  end
end
