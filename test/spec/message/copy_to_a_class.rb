require_relative 'message_init'

describe "Copy Message Attributes to a Class" do
  source = EventStore::Messaging::Controls::Message.example
  receiver = EventStore::Messaging::Message::Copy.(source, source.class)

  specify "Constructs the class" do
    assert(source.class == receiver.class)
  end

  specify "Copies the attributes" do
    assert(source == receiver)
  end
end
