require_relative 'client_integration_init'

message = Fixtures.some_message_with_metadata
message.some_attribute = 'some value'

writer = EventStore::Messaging::Writer.build

category_id = UUID.random.gsub('-', '')

stream_name = "testReply#{category_id}-#{UUID.random}"

reply_stream_name = "replyToTestReply#{category_id}-#{UUID.random}"

writer.write message, stream_name, reply_stream_name: reply_stream_name
