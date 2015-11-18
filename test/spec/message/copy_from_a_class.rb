require_relative 'message_init'

describe "Copy Message Attributes from a Class" do
  source = EventStore::Messaging::Controls::Message.example
  receiver = EventStore::Messaging::Controls::Message.message_class.copy(source)

  specify "Constructs the class" do
    assert(receiver.class == EventStore::Messaging::Controls::Message.message_class)
  end

  specify "Copies the attributes" do
    assert(source == receiver)
  end
end
