require_relative 'spec_init'

describe "Message Metadata" do
  specify "Has message metadata" do
    message = Fixtures.some_message

    message.metadata.id = 'some id'
    message.metadata.correlation_stream = 'some correlation stream'
    message.metadata.causation_stream = 'some causation stream'
    message.metadata.reply_stream = 'some reply stream'


    puts message.metadata.id
    puts message.metadata.correlation_stream
    puts message.metadata.causation_stream
    puts message.metadata.reply_stream


    puts message.message_type # => SomeMessage
    puts message.message_name # => some_message

    # - - -

    puts message.metadata.type
    puts message.metadata.name
  end
end
