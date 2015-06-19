require_relative 'spec_init'

describe "Convert message to stream entry" do
  message = Fixtures.some_message
  message.some_attribute = 'some value'
  event_data = EventStore::Messaging::Message::Conversion::EventData.! message

  specify "An ID is assigned to the event data" do
    refute(event_data.nil?)
  end

  specify "The event data type is the message type" do
    assert(event_data.type == 'SomeMessage')
  end

  specify "Data" do
    entry_data = {
      some_attribute: "some value"
    }

    assert(event_data.data == entry_data)
  end
end
