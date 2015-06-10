require_relative 'spec_init'

describe "Message Class" do
  specify "Message name is the inner-most namespace of message's class name" do
    name = Fixtures::SomeEvent.message_type
    assert(name == "SomeEvent")
  end

  specify "Message name is the message name in snake case" do
    name = Fixtures::SomeEvent.message_name
    assert(name == "some_event")
  end
end

describe "Message Instance" do
  specify "Message name is the inner-most namespace of message's class name" do
    type = Fixtures.message.message_type
    assert(type == "SomeEvent")
  end

  specify "Message name is the message name in snake case" do
    name = Fixtures.message.message_name
    assert(name == "some_event")
  end
end
