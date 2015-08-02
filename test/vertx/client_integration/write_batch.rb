raise NotImplementedError

require_relative 'client_integration_init'

message1 = Fixtures.some_message_with_metadata
message1.some_attribute = 'some value'

message2 = Fixtures.some_message_with_metadata
message2.some_attribute = 'some other value'

writer = EventStore::Messaging::Writer.build

# TODO Put stream name generator in fixtures (as in the client lib) [Scott, Wed Jul 15 2015]
category_name = "testWriter#{UUID.random.gsub('-', '')}"
stream_name = "#{category_name}-#{UUID.random}"

batch = []
batch << message1
batch << message2

writer.write batch, stream_name, reply_stream_name: nil

# writer adds single to array if single, then proceeds with common case (multiple)
# serialize each to event_data instances
# add each event_data to array
# pass array to client writer
# client writer adds single to array if single, then proceeds with common case (multiple)


