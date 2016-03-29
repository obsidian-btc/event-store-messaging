require_relative '../message_init'

context "Proceed from Previous Message to a Class" do
  source = EventStore::Messaging::Controls::Message.example
  msg = EventStore::Messaging::Message::Proceed.(source, source.class)

  source_metadata = source.metadata
  metadata = msg.metadata

  test "Constructs the class" do
    assert(msg.class == source.class)
  end

  test "Metadata have precedence" do
    assert(metadata.precedence?(source_metadata))
  end
end
