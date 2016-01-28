require_relative '../message_init'

context "Copy Mapped Message Attributes" do
  test "Attributes are copied according to mapping" do
    source = EventStore::Messaging::Controls::Message::Mapped.example
    receiver = EventStore::Messaging::Controls::Message.message_class.new

    EventStore::Messaging::Message::Copy.(source, receiver, copy: [
      { :an_attribute => :some_attribute },
      :some_time
    ])

    assert(receiver.some_attribute == source.an_attribute)
    assert(receiver.some_time == source.some_time)
  end
end
