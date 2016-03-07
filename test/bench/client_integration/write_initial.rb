require_relative './client_integration_init'

context "Initial Event" do
  context "Writing the initial event to a stream that has not been created yet" do
    substitute_writer = EventStore::Messaging::Writer::Substitute.build

    stream_name = EventStore::Messaging::Controls::StreamName.get 'testWriter'
    message = EventStore::Messaging::Controls::Message.example

    substitute_writer.write_initial message, stream_name

    test "Has an expected version of :no_stream" do
      assert(substitute_writer.written? { |msg, stream, expected_version | message == msg && expected_version == :no_stream })
    end
  end

  context "Writing the initial event to a stream that was previously created by the writing of another event" do
    writer = EventStore::Messaging::Writer.build

    message = EventStore::Messaging::Controls::Message.example
    stream_name = EventStore::Messaging::Controls::StreamName.get 'testWriter'

    writer.write message, stream_name

    test "Is an error" do
      assert proc { writer.write_initial message, stream_name } do
        raises_error? EventStore::Client::HTTP::Request::Post::ExpectedVersionError
      end
    end
  end
end
