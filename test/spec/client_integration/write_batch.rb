require_relative 'client_integration_init'

describe "Write Batch of Events" do
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

  read_data_1 = EventStore::Client::HTTP::EventData::Read.parse body_text_1
  read_data_2 = EventStore::Client::HTTP::EventData::Read.parse body_text_2

  2.times do |i|
    i += 1
    event_data = eval("read_data_#{i}")

    specify "Individual events are written" do
      assert(event_data.data['some_attribute'] == eval("token_#{i}"))
    end
  end
end
