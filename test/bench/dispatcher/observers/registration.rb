require_relative '../../bench_init'

context "Observer registration" do
  observers = EventStore::Messaging::Dispatcher::Observers.build

  observer = proc { }

  context do
    event = EventStore::Messaging::Controls::Dispatcher::Observers::Event.example

    registration = observers.register event, &observer

    test "Registering an observer" do
      assert observers.registry[registration.id].observer == observer
    end

    test "Assertions" do
      assert observers do
        notify? observer, event
      end
    end

    test "Unregistering an observer" do
      observers.unregister registration

      assert observers.registry[registration.id].nil?
    end
  end

  test "Message is about to be dispatched" do
    observers.dispatching &observer

    assert observers do
      notify_dispatching? observer
    end
  end

  test "Message was dispatched" do
    observers.dispatched &observer

    assert observers do
      notify_dispatched? observer
    end
  end

  test "An error occurred during a message dispatch" do
    observers.failed &observer

    assert observers do
      notify_failed? observer
    end
  end
end
