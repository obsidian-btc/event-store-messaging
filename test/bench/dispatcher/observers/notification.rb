require_relative '../../bench_init'

context "Notifying observers" do
  observers = EventStore::Messaging::Dispatcher::Observers.build

  control_message = EventStore::Messaging::Controls::Message.example

  context "Message is about to be dispatched" do
    notified = false

    observers.dispatching do
      notified = true
    end

    observers.notify :dispatching, control_message

    test "Observer is notified" do
      assert notified
    end
  end

  context "Message was dispatched" do
    notified = false

    observers.dispatched do |n|
      notified = true
    end

    observers.notify :dispatched, control_message

    test "Observer is notified" do
      assert notified
    end
  end

  context "An error occurred during a message dispatch" do
    notified = false

    observers.failed do
      notified = true
    end

    observers.notify :failed, control_message

    test "Observer is notified" do
      assert notified
    end
  end

  test "Returns list of observers notified" do
    event = EventStore::Messaging::Controls::Dispatcher::Observers::Event.example

    observer1 = proc {}
    observer2 = proc {}

    observers.register event, &observer1
    observers.register event, &observer2

    observers_notified = observers.notify event, control_message

    assert observers_notified == [observer1, observer2]
  end

  context "Observers do not receive notifications for unrelated events" do
    message = nil
    observed_event = EventStore::Messaging::Controls::Dispatcher::Observers::Event.unique
    notified_event = EventStore::Messaging::Controls::Dispatcher::Observers::Event.unique

    observers.register observed_event do |msg|
      message = msg
    end

    observers.notify notified_event, control_message

    test do
      assert message.nil?
    end
  end

  context "Arity" do
    event = EventStore::Messaging::Controls::Dispatcher::Observers::Event.example
    control_event_data = EventStore::Messaging::Controls::EventData::Read.example

    test "0-arity" do
      notified = false

      observers.register event do
        notified = true
      end

      observers.notify event, control_message

      assert notified
    end

    test "1-arity" do
      message = nil

      observers.register event do |msg|
        message = msg
      end

      observers.notify event, control_message

      assert message == control_message
    end

    test "2-arity" do
      event_data = nil

      observers.register event do |_, data|
        event_data = data
      end

      observers.notify event, control_message, control_event_data

      assert event_data == control_event_data
    end

    test "3-arity" do
      control_error = RuntimeError.new
      error = nil

      observers.register event do |_, _, _error|
        error = _error
      end

      observers.notify event, control_message, control_event_data, control_error

      assert error == control_error
    end
  end
end
