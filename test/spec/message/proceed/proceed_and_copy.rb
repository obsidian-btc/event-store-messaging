require_relative '../message_init'

describe "Proceed from Previous Message and Copy Message Attributes" do
  let(:source) { EventStore::Messaging::Controls::Message.example }
  let(:receiver) { source.class.new }

  context "By default" do
    specify "Copies attributes" do
      EventStore::Messaging::Message::Proceed.(source, receiver, copy: true)
      assert(source == receiver)
    end

    specify "Metadata have precedence" do
      EventStore::Messaging::Message::Proceed.(source, receiver, copy: true)
      assert(receiver.precedence?(source))
    end
  end

  specify "Including all attributes" do
    EventStore::Messaging::Message::Proceed.(source, receiver, include: [
      :some_attribute,
      :some_time
    ])

    assert(source == receiver)
  end

  context "Alternate syntax using `copy` as include" do
    specify "Copies attributes" do
EventStore::Messaging::Message::Proceed.(source, receiver, copy: [
  :some_attribute,
  :some_time
])

      assert(source == receiver)
    end
  end


  specify "Including some attributes" do
    EventStore::Messaging::Message::Proceed.(source, receiver, include: :some_attribute)

    assert(source.some_attribute == receiver.some_attribute)
    refute(source.some_time == receiver.some_time)
  end

  specify "Excluding all attributes" do
    EventStore::Messaging::Message::Proceed.(source, receiver, exclude: [
      :some_attribute,
      :some_time
    ])

    refute(source.some_attribute == receiver.some_attribute)
    refute(source.some_time == receiver.some_time)
  end

  specify "Excluding some attributes" do
    EventStore::Messaging::Message::Proceed.(source, receiver, exclude: :some_time)

    assert(source.some_attribute == receiver.some_attribute)
    refute(source.some_time == receiver.some_time)
  end
end
