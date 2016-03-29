require_relative '../message_init'

context "Proceed from Previous Message and Copy Mapped Message Attributes" do
  source = EventStore::Messaging::Controls::Message::Mapped.example
  receiver = EventStore::Messaging::Controls::Message.message_class.new

  test "Attributes are copied according to mapping" do
    EventStore::Messaging::Message::Proceed.(source, receiver, copy: [
      { :an_attribute => :some_attribute },
      :some_time
    ])

    assert(receiver.some_attribute == source.an_attribute)
    assert(receiver.some_time == source.some_time)
  end
end
