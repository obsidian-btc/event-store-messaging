require_relative './client_integration_init'

context "Message Writer" do
  test "Writes a message" do
    message = EventStore::Messaging::Controls::Message.example

    writer = EventStore::Messaging::Writer.build

    stream_name = EventStore::Messaging::Controls::StreamName.get 'testWriter'

    writer.write message, stream_name

    path = "/streams/#{stream_name}"
    get = EventStore::Client::HTTP::Request::Get.build
    body_text, get_response = get.("#{path}/0")

    assert(!body_text.nil?)
  end
end
