require_relative '../bench_init'

context "Configuring a receiver" do
  receiver = OpenStruct.new
  dispatcher_class = EventStore::Messaging::Controls::Dispatcher::SomeDispatcher

  context "Default attribute name" do
    dispatcher_class.configure receiver

    test "The receiver has an instance of the dispatcher" do
      assert receiver.dispatcher.is_a?(dispatcher_class)
    end
  end

  context "Specific attribute name" do
    dispatcher_class.configure receiver, :attr_name => :some_attr

    test "The receiver has an instance of the dispatcher" do
      assert receiver.some_attr.is_a?(dispatcher_class)
    end
  end
end
