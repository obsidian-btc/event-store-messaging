require_relative 'message_init'

describe "Message Equality" do
  val_1 = Controls::ID.get
  val_2 = Controls::ID.get

  message = EventStore::Messaging::Controls::Message.example
  message.some_attribute = val_1
  message.some_time = val_2

  other_message = EventStore::Messaging::Controls::Message.example

  describe "Equal" do
    specify "When attributes are equal" do
      other_message.some_attribute = val_1
      other_message.some_time = val_2

      assert(message == other_message)
    end
  end

  describe "Not Equal" do
    specify "When message classes aren't equal" do
      other_message = EventStore::Messaging::Controls::Message::NotEqualMessage.new

      other_message.some_attribute = val_1
      other_message.some_time = val_2

      refute(message == other_message)
    end

    specify "When data isn't equal" do
      other_message.some_attribute = "X #{val_1}"
      other_message.some_time = "X #{val_2}"

      refute(message == other_message)
    end
  end
end
