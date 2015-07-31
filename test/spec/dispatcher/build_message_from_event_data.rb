require_relative 'dispatcher_init'

describe "Build Message from Event Data" do
  describe "Message corresponding to the event data type is built from the event data" do
    event_data = EventStore::Messaging::Controls::EventData::Read.example

    dispatcher_class = EventStore::Messaging::Controls::Dispatcher.dispatcher_class
    message = dispatcher_class.build_message event_data

    specify "Message type" do
      assert(message.is_a? EventStore::Messaging::Controls::Message::SomeMessage)
    end

    specify "Data" do
      assert(message.some_attribute == EventStore::Messaging::Controls::Message.attribute)
      assert(message.some_time == EventStore::Messaging::Controls::Message.time)
    end
  end
end

describe "Build Message from Event Data for Type that Is Not Registered" do
  specify "Message is nil" do
    event_data = EventStore::Messaging::Controls::EventData::Read::Anomaly.example

    dispatcher_class = EventStore::Messaging::Controls::Dispatcher.dispatcher_class
    message = dispatcher_class.build_message event_data

    assert(message.nil?)
  end
end
