require_relative 'client_integration_init'

message = Fixtures.some_message
message.some_attribute = 'some value'

writer = EventStore::Messaging::Writer.build

category_name = "testWriter#{UUID.random.gsub('-', '')}"
stream_name = "#{category_name}-#{UUID.random}"

writer.write message, stream_name
