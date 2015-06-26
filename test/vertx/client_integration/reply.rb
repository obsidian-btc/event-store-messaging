require_relative 'client_integration_init'

reply_category_name = "testReply#{UUID.random.gsub('-', '')}"
reply_stream_name = "#{reply_category_name}-#{UUID.random}"

message = Fixtures.some_message
message.metadata.reply_stream_name = reply_stream_name

writer = EventStore::Messaging::Writer.build

writer.reply message
