require_relative 'message_init'

describe "Message Class" do
  message_class = EventStore::Messaging::Controls::Message.message_class

  specify "Message name is the inner-most namespace of message's class name" do
    name = message_class.message_type
    assert(name == "SomeMessage")
  end

  specify "Message name is the message name in snake case" do
    name = message_class.message_name
    assert(name == "some_message")
  end
end

describe "Message Instance" do
  message = EventStore::Messaging::Controls::Message.example

  specify "Message name is the inner-most namespace of message's class name" do
    type = message.message_type
    assert(type == "SomeMessage")
  end

  specify "Message name is the message name in snake case" do
    name = message.message_name
    assert(name == "some_message")
  end
end
