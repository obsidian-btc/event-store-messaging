require_relative '../message_init'

context "Copy Message Attributes" do
  test "All attributes by default" do
    source = EventStore::Messaging::Controls::Message.example
    receiver = source.class.new

    EventStore::Messaging::Message::Copy.(source, receiver)
    assert(source == receiver)
  end

  test "Including all attributes" do
    source = EventStore::Messaging::Controls::Message.example
    receiver = source.class.new

    EventStore::Messaging::Message::Copy.(source, receiver, include: [
      :some_attribute,
      :some_time
    ])

    assert(source == receiver)
  end

  test "Including some attributes" do
    source = EventStore::Messaging::Controls::Message.example
    receiver = source.class.new

    EventStore::Messaging::Message::Copy.(source, receiver, include: :some_attribute)

    assert(source.some_attribute == receiver.some_attribute)
    assert(source.some_time != receiver.some_time)
  end

  test "Excluding all attributes" do
    source = EventStore::Messaging::Controls::Message.example
    receiver = source.class.new

    EventStore::Messaging::Message::Copy.(source, receiver, exclude: [:some_attribute, :some_time])

    assert(source.some_attribute != receiver.some_attribute)
    assert(source.some_time != receiver.some_time)
  end

  test "Excluding some attributes" do
    source = EventStore::Messaging::Controls::Message.example
    receiver = source.class.new

    EventStore::Messaging::Message::Copy.(source, receiver, exclude: :some_time)

    assert(source.some_attribute == receiver.some_attribute)
    assert(source.some_time != receiver.some_time)
  end
end
