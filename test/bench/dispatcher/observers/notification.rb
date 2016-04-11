require_relative '../../bench_init'

context "Notifying observers" do
  observers = EventStore::Messaging::Dispatcher::Observers.build

  control_notification = EventStore::Messaging::Controls::Dispatcher::Observers::Notification.example

  context "Message is about to be dispatched" do
    notification = nil

    observers.dispatching do |n|
      notification = n
    end

    observers.notify :dispatching, control_notification

    test do
      assert notification == control_notification
    end
  end

  test "Message was dispatched" do
    notification = nil

    observers.dispatched do |n|
      notification = n
    end

    observers.notify :dispatched, control_notification

    test do
      assert notification == control_notification
    end
  end

  test "An error occurred during a message dispatch" do
    notification = nil

    observers.failed do |n|
      notification = n
    end

    observers.notify :failed, control_notification

    test do
      assert notification == control_notification
    end
  end

  test "Number of observers notified is returned" do
    event = EventStore::Messaging::Controls::Dispatcher::Observers::Event.example

    observers.register(event) {}
    observers.register(event) {}
    observers.register(event) {}

    observers_notified = observers.notify event, control_notification

    assert observers_notified == 3
  end

  test "Observers do not receive notifications for unrelated events" do
    message = nil
    observed_event = EventStore::Messaging::Controls::Dispatcher::Observers::Event.unique
    notified_event = EventStore::Messaging::Controls::Dispatcher::Observers::Event.unique

    observers.register observed_event do |msg|
      message = msg
    end

    observers.notify notified_event, control_notification

    test do
      assert message.nil?
    end
  end

  context "Arity" do
    event = EventStore::Messaging::Controls::Dispatcher::Observers::Event.example

    test "0-arity" do
      notified = false

      observers.register event do
        notified = true
      end

      observers.notify event, control_notification

      assert notified
    end

    test "1-arity" do
      notified = false

      observers.register event do
        notified = true
      end

      observers.notify event, control_notification

      assert notified
    end
  end
end
