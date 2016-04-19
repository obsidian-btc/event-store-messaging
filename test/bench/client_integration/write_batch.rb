require_relative 'client_integration_init'

context "Write Batch of Events" do
  message = EventStore::Messaging::Controls::Message.example

  stream_name = EventStore::Messaging::Controls::StreamName.get 'testBatch'

  path = "/streams/#{stream_name}"

  writer = EventStore::Client::HTTP::EventWriter.build

  token_1 = Controls::ID.get 1
  token_2 = Controls::ID.get 2

  message_1 = EventStore::Messaging::Controls::Message.example
  message_2 = EventStore::Messaging::Controls::Message.example

  message_1.some_attribute = token_1
  message_2.some_attribute = token_2

  writer = EventStore::Messaging::Writer.build
  writer.write [message_1, message_2], stream_name

  get = EventStore::Client::HTTP::Request::Get.build
  body_text_1, get_response = get.("#{path}/0")
  body_text_2, get_response = get.("#{path}/1")

  read_data_1 = Serialize::Read.(body_text_1, EventStore::Client::HTTP::EventData::Read, :json)
  read_data_2 = Serialize::Read.(body_text_2, EventStore::Client::HTTP::EventData::Read, :json)

  2.times do |i|
    i += 1
    event_data = binding.local_variable_get "read_data_#{i}"

    test "Individual events are written" do
      control_attribute = binding.local_variable_get "token_#{i}"

      assert event_data.data[:some_attribute] == control_attribute
    end
  end
end
