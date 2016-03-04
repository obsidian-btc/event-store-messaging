require_relative 'client_integration_init'

context "Replying to a Message" do
  message = EventStore::Messaging::Controls::Message.example

  writer = EventStore::Messaging::Writer.build

  stream_name = EventStore::Messaging::Controls::StreamName.get 'testReply'

  reply_stream_name = EventStore::Messaging::Controls::StreamName.get 'replyToTestReply'

  message.metadata.reply_stream_name = reply_stream_name

  writer.reply message

  test "Writes the message to the reply stream" do
    path = "/streams/#{reply_stream_name}"
    get = EventStore::Client::HTTP::Request::Get.build
    body_text, get_response = get.("#{path}/0")

    assert(!body_text.nil?)
  end
end
