require_relative '../message_init'

context "Proceed from Previous Message and Copy Message Attributes" do
  context "By default" do
    source = EventStore::Messaging::Controls::Message.example
    receiver = source.class.new

    test "Copies attributes" do
      EventStore::Messaging::Message::Proceed.(source, receiver, copy: true)
      assert(source == receiver)
    end

    test "Metadata have precedence" do
      EventStore::Messaging::Message::Proceed.(source, receiver, copy: true)
      assert(receiver.precedence?(source))
    end
  end

  test "Including all attributes" do
    source = EventStore::Messaging::Controls::Message.example
    receiver = source.class.new

    EventStore::Messaging::Message::Proceed.(source, receiver, include: [
      :some_attribute,
      :some_time
    ])

    assert(source == receiver)
  end

  context "Alternate syntax using `copy` as include" do
    source = EventStore::Messaging::Controls::Message.example
    receiver = source.class.new

    test "Copies attributes" do
      EventStore::Messaging::Message::Proceed.(source, receiver, copy: [
        :some_attribute,
        :some_time
      ])

      assert(source == receiver)
    end
  end


  test "Including some attributes" do
    source = EventStore::Messaging::Controls::Message.example
    receiver = source.class.new

    EventStore::Messaging::Message::Proceed.(source, receiver, include: :some_attribute)

    assert(source.some_attribute == receiver.some_attribute)
    assert(source.some_time != receiver.some_time)
  end

  test "Excluding all attributes" do
    source = EventStore::Messaging::Controls::Message.example
    receiver = source.class.new

    EventStore::Messaging::Message::Proceed.(source, receiver, exclude: [
      :some_attribute,
      :some_time
    ])

    assert(source.some_attribute != receiver.some_attribute)
    assert(source.some_time != receiver.some_time)
  end

  test "Excluding some attributes" do
    source = EventStore::Messaging::Controls::Message.example
    receiver = source.class.new

    EventStore::Messaging::Message::Proceed.(source, receiver, exclude: :some_time)

    assert(source.some_attribute == receiver.some_attribute)
    assert(source.some_time != receiver.some_time)
  end
end
