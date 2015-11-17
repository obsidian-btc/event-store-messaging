require_relative 'message_init'

describe "Copy Message Attributes" do
  specify "All attributes" do
    msg_1 = EventStore::Messaging::Controls::Message.example
    msg_2 = msg_1.class.new

    EventStore::Messaging::Message::Copy.(msg_1, msg_2)

    assert(msg_1 == msg_2)
  end

  specify "Including all attributes" do
    msg_1 = EventStore::Messaging::Controls::Message.example
    msg_2 = msg_1.class.new

    EventStore::Messaging::Message::Copy.(msg_1, msg_2, include: [
      :some_attribute,
      :some_time
    ])

    assert(msg_1 == msg_2)
  end

  specify "Including some attributes" do
    msg_1 = EventStore::Messaging::Controls::Message.example
    msg_2 = msg_1.class.new

    EventStore::Messaging::Message::Copy.(msg_1, msg_2, include: :some_attribute)

    assert(msg_1.some_attribute == msg_2.some_attribute)
    refute(msg_1.some_time == msg_2.some_time)
  end

  specify "Excluding all attributes" do
    msg_1 = EventStore::Messaging::Controls::Message.example
    msg_2 = msg_1.class.new

    EventStore::Messaging::Message::Copy.(msg_1, msg_2, exclude: [:some_attribute, :some_time])

    refute(msg_1.some_attribute == msg_2.some_attribute)
    refute(msg_1.some_time == msg_2.some_time)
  end

  specify "Excluding some attributes" do
    msg_1 = EventStore::Messaging::Controls::Message.example
    msg_2 = msg_1.class.new

    EventStore::Messaging::Message::Copy.(msg_1, msg_2, exclude: [:some_time])

    assert(msg_1.some_attribute == msg_2.some_attribute)
    refute(msg_1.some_time == msg_2.some_time)
  end
end
