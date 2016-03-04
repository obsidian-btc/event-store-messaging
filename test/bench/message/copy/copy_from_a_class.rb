require_relative '../message_init'

context "Copy Message Attributes from a Class" do
  source = EventStore::Messaging::Controls::Message.example
  receiver = EventStore::Messaging::Controls::Message.message_class.copy(source)

  test "Constructs the class" do
    assert(receiver.class == EventStore::Messaging::Controls::Message.message_class)
  end

  test "Copies the attributes" do
    assert(source == receiver)
  end
end
