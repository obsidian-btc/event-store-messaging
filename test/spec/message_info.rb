require_relative 'spec_init'

describe "Message Class" do
  specify "Message name is the inner-most namespace of message's class name" do
    name = Fixtures::SomeEvent.message_name
    assert(name == "SomeEvent")
  end

  specify "Message identifier is the message name in snake case" do
    identifier = Fixtures::SomeEvent.message_identifier
    assert(identifier == "some_event")
  end
end

describe "Message Instance" do
  specify "Message name is the inner-most namespace of message's class name" do
    name = Fixtures.message.message_name
    assert(name == "SomeEvent")
  end

  specify "Message identifier is the message name in snake case" do
    identifier = Fixtures.message.message_identifier
    assert(identifier == "some_event")
  end
end
