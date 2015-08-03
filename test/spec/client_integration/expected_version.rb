require_relative 'client_integration_init'

describe "Writing the Expected Version Number" do
  stream_name = EventStore::Messaging::Controls::StreamName.get 'testWrongVersion'
  writer = EventStore::Messaging::Writer.build

  message_1 = EventStore::Messaging::Controls::Message.example
  writer.write message_1, stream_name

  message_2 = EventStore::Messaging::Controls::Message.example

  describe "Right Version" do
    specify "Succeeds" do
      writer.write message_2, stream_name, expected_version: 0
    end
  end

  describe "Wrong Version" do
    specify "Fails" do
      assert_raises(EventStore::Client::HTTP::Request::Post::ExpectedVersionError) do
        writer.write message_2, stream_name, expected_version: 11
      end
    end
  end
end
