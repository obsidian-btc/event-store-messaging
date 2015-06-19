require_relative 'client_integration_init'

message = Fixtures.some_message
message.some_attribute = 'some value'

category_name ||= "someStream#{UUID.random.gsub('-', '')}"

writer = EventStore::Messaging::Writer.build category_name

writer.write message
