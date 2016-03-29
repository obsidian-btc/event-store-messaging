require_relative 'client_integration_init'

context "Writing the Expected Version Number" do
  stream_name = EventStore::Messaging::Controls::StreamName.get 'testWrongVersion'
  writer = EventStore::Messaging::Writer.build

  message_1 = EventStore::Messaging::Controls::Message.example
  writer.write message_1, stream_name

  message_2 = EventStore::Messaging::Controls::Message.example

  context "Right Version" do
    test "Succeeds" do
      writer.write message_2, stream_name, expected_version: 0
    end
  end

  context "Wrong Version" do
    test "Fails" do
      assert proc { writer.write message_2, stream_name, expected_version: 11 } do
        raises_error? EventStore::Client::HTTP::Request::Post::ExpectedVersionError
      end
    end
  end
end
