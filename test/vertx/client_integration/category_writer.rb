require_relative 'client_integration_init'

message = Fixtures.some_message
message.some_attribute = 'some value'

category_name = "testCategoryWriter#{UUID.random.gsub('-', '')}"

writer = EventStore::Messaging::CategoryWriter.build category_name

stream_id = UUID.random

writer.write message, stream_id
