require_relative 'spec_init'

describe "Message Class" do
  specify "Message name is the inner-most namespace of message's class name" do
    name = Fixtures::SomeMessage.message_name
    assert(name == "SomeMessage")
  end

  specify "Message identifier is the message name in snake case" do
    identifier = Fixtures::SomeMessage.message_identifier
    assert(identifier == "some_message")
  end
end

describe "Message Instance" do
  specify "Message name is the inner-most namespace of message's class name" do
    name = Fixtures.message.message_name
    assert(name == "SomeMessage")
  end

  specify "Message identifier is the message name in snake case" do
    identifier = Fixtures.message.message_identifier
    assert(identifier == "some_message")
  end
end
