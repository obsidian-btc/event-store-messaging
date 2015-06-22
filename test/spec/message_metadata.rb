require_relative 'spec_init'

describe "Message Metadata" do
  specify "Has message metadata" do
    message = Fixtures.some_message

    message.metadata.id = 'some id'
    message.metadata.correlation_id = 'some correlation id'
    message.metadata.causation_id = 'some causation id'


    puts message.metadata.id
    puts message.metadata.correlation_id
    puts message.metadata.causation_id


    puts message.message_type # => SomeMessage
    puts message.message_name # => some_message

    # - - -

    puts message.metadata.type
    puts message.metadata.name
  end
end
