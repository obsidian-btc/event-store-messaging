require_relative '../message_init'

describe "Copy Message Attributes" do
  let(:source) { EventStore::Messaging::Controls::Message.example }
  let(:receiver) { source.class.new }

  specify "All attributes by default" do
    EventStore::Messaging::Message::Copy.(source, receiver)
    assert(source == receiver)
  end

  specify "Including all attributes" do
    EventStore::Messaging::Message::Copy.(source, receiver, include: [
      :some_attribute,
      :some_time
    ])

    assert(source == receiver)
  end

  specify "Including some attributes" do
    EventStore::Messaging::Message::Copy.(source, receiver, include: :some_attribute)

    assert(source.some_attribute == receiver.some_attribute)
    refute(source.some_time == receiver.some_time)
  end

  specify "Excluding all attributes" do
    EventStore::Messaging::Message::Copy.(source, receiver, exclude: [:some_attribute, :some_time])

    refute(source.some_attribute == receiver.some_attribute)
    refute(source.some_time == receiver.some_time)
  end

  specify "Excluding some attributes" do
    EventStore::Messaging::Message::Copy.(source, receiver, exclude: :some_time)

    assert(source.some_attribute == receiver.some_attribute)
    refute(source.some_time == receiver.some_time)
  end
end
