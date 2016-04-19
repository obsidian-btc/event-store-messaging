require_relative '../bench_init'

context "Configuring a Receiver of a Dispatcher" do
  receiver = OpenStruct.new

  context "Default attribute name" do
    EventStore::Messaging::Controls::Dispatcher::SomeDispatcher.configure receiver

    test "The receiver has an instance of the dispatcher" do
      assert receiver.dispatcher.is_a?(EventStore::Messaging::Controls::Dispatcher::SomeDispatcher)
    end
  end

  context "Specific attribute name" do
    EventStore::Messaging::Controls::Dispatcher::SomeDispatcher.configure receiver, attr_name: :some_attr

    test "The receiver has an instance of the dispatcher" do
      assert receiver.some_attr.is_a?(EventStore::Messaging::Controls::Dispatcher::SomeDispatcher)
    end
  end
end
