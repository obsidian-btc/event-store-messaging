require_relative '../message_init'

context "Copy Message Attributes to a Class" do
  source = EventStore::Messaging::Controls::Message.example
  receiver = EventStore::Messaging::Message::Copy.(source, source.class)

  test "Constructs the class" do
    assert(receiver.class == source.class)
  end

  test "Copies the attributes" do
    assert(source == receiver)
  end
end
