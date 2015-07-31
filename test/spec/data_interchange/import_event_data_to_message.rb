require_relative 'data_interchange_init.rb'

describe "Import Event Data to Message" do
  event_data = EventStore::Messaging::Controls::EventData::Read.example

  message_class = EventStore::Messaging::Controls::Message.message_class

  message = EventStore::Messaging::Message::Export::EventData.! event_data, message_class

  specify "Message class is the event data type"

  specify "Message data is the event data"
  specify "Message metadata is the event metadata"
end
