require_relative '../message_init'

describe "Proceed from Previous Message from a Class" do
  let(:source) { EventStore::Messaging::Controls::Message.example }

  let(:source_metadata) { source.metadata }
  let(:metadata) { msg.metadata }

  let(:msg) { EventStore::Messaging::Controls::Message.message_class.proceed(source) }

  specify "Constructs the class" do
    assert(msg.class == source.class)
  end

  specify "Metadata have precedence" do
    assert(metadata.precedence?(source_metadata))
  end
end
