require_relative 'spec_init'

describe "Convert message to stream entry" do
  message = Fixtures.some_message
  message.some_attribute = 'some value'
  stream_entry = EventStore::Messaging::Message::Conversion::StreamEntry.! message

  specify "Type" do
    assert(stream_entry.type == 'SomeMessage')
  end

  specify "Data" do
    entry_data = {
      some_attribute: "some value"
    }

    assert(stream_entry.data == entry_data)
  end
end
