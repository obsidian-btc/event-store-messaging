require_relative '../message_init'

describe "Message Copying Strictness" do
  context "Strict" do
    context "Receiver has same attributes as source" do
      source = EventStore::Messaging::Controls::Message.example
      receiver = source.class.new

      EventStore::Messaging::Message::Copy.(source, receiver)

      specify do
        assert(source == receiver)
      end
    end

    context "Receiver doesn't have all of the source's attributes" do
      source = EventStore::Messaging::Controls::Message.example
      receiver = EventStore::Messaging::Controls::Message::FewerAttributesMessage.new

      specify "Is an error" do
        assert_raises EventStore::Messaging::Message::Copy::Error do
          EventStore::Messaging::Message::Copy.(source, receiver)
        end
      end
    end
  end

  context "Not Strict" do
    context "Receiver doesn't have all of the source's attributes" do
      source = EventStore::Messaging::Controls::Message.example
      receiver = EventStore::Messaging::Controls::Message::FewerAttributesMessage.new

      EventStore::Messaging::Message::Copy.(source, receiver, strict: false)

      specify "Copies the attributes supported by the receiver" do
        assert(source.some_attribute == receiver.some_attribute)
      end
    end
  end
end
