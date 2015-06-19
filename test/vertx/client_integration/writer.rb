require_relative 'client_integration_init'

message = Fixtures.some_message
message.some_attribute = 'some value'

category_name ||= "someStream#{UUID.random.gsub('-', '')}"

writer = EventStore::Messaging::Writer.build category_name

writer.write message



# Vertx.set_timer(1_500) do
#   assert(stream_entries.length == 1)
#   assert(stream_entries[0].type == "SomeEvent")

#   logger(__FILE__).data stream_entries.inspect
# end
