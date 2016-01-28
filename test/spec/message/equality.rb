require_relative 'message_init'

context "Message Equality" do
  val_1 = Controls::ID.get
  val_2 = Controls::ID.get

  message = EventStore::Messaging::Controls::Message.example
  message.some_attribute = val_1
  message.some_time = val_2

  context "Equal" do
    test "When attributes are equal" do
      other_message = EventStore::Messaging::Controls::Message.example
      other_message.some_attribute = val_1
      other_message.some_time = val_2

      assert(message == other_message)
    end
  end

  context "Not Equal" do
    test "When message classes aren't equal" do
      other_message = EventStore::Messaging::Controls::Message::NotEqualMessage.new

      other_message.some_attribute = val_1
      other_message.some_time = val_2

      assert(message != other_message)
    end

    test "When data isn't equal" do
      other_message = EventStore::Messaging::Controls::Message.example
      other_message.some_attribute = "X #{val_1}"
      other_message.some_time = "X #{val_2}"

      assert(message != other_message)
    end
  end
end
