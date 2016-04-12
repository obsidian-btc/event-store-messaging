require_relative '../../bench_init'

context "Observing dispatcher events" do
  message = EventStore::Messaging::Controls::Message.example
  event_data = EventStore::Messaging::Controls::EventData::Read.example

  dispatcher = EventStore::Messaging::Controls::Dispatcher.example

  context "Notifications" do
    context "Successful message dispatch" do
      dispatcher.dispatch message, event_data

      test "Observers are notified when message is about to be dispatched" do
        assert dispatcher.observers do
          notified? :dispatching, message, event_data: event_data
        end
      end

      test "Observers are notified when message has been dispatched" do
        assert dispatcher.observers do
          notified? :dispatched, message, event_data: event_data
        end
      end
    end

    context "Failed message dispatch" do
      dispatcher.register_handler EventStore::Messaging::Controls::Handler::FailsWhenHandlingMessage

      begin
        dispatcher.dispatch message, event_data
      rescue RuntimeError => error
      end

      test "Observers are notified when message is about to be dispatched" do
        assert dispatcher.observers do
          notified? :dispatching, message, event_data: event_data
        end
      end

      test "Observers are notified when message dispatch has failed" do
        assert dispatcher.observers do
          notified? :failed, message, event_data: event_data, error: error
        end
      end
    end
  end

  context "Registering observers" do
    test "Message is about to be dispatched" do
      observer = proc { }

      dispatcher.dispatching &observer

      assert dispatcher.observers do
        notify_dispatching? observer
      end
    end

    test "Message was dispatched" do
      observer = proc { }

      dispatcher.dispatched &observer

      assert dispatcher.observers do
        notify_dispatched? observer
      end
    end

    test "An error occurred during a message dispatch" do
      observer = proc { }

      dispatcher.failed &observer

      assert dispatcher.observers do
        notify_failed? observer
      end
    end

    test "Removing observers" do
      observer = proc { }

      registration = dispatcher.dispatching &observer
      dispatcher.remove_observer registration

      refute dispatcher.observers do
        notify_dispatching? observer
      end
    end
  end
end
