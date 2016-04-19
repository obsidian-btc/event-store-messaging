require_relative '../../bench_init'

context "Configure a Receiver of Observers" do
  receiver = OpenStruct.new

  context "Default attribute name" do
    test "The receiver has an instance of the observers object" do
      EventStore::Messaging::Dispatcher::Observers.configure receiver

      assert receiver.observers.is_a?(EventStore::Messaging::Dispatcher::Observers)
    end
  end

  context "Specific attribute name" do
    test "The receiver has an instance of the observers object" do
      EventStore::Messaging::Dispatcher::Observers.configure receiver, :attr_name => :other_attr

      assert receiver.other_attr.is_a?(EventStore::Messaging::Dispatcher::Observers)
    end
  end
end
