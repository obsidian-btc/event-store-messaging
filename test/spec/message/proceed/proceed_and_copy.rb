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
end
