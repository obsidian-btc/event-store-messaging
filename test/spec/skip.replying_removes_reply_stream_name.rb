require_relative 'spec_init'

describe "Replying" do
  specify "Removes the reply stream name from the message metadata" do
    writer = EventStore::Messaging::Writer.new

    message = Fixtures.some_message

    message.metadata.reply_stream_name = "someStreamToReplyTo"

    writer.reply message

    assert(message.metadata.reply_stream_name.nil?)
  end

  specify "Is an error if the message has no reply stream name" do
    writer = EventStore::Messaging::Writer.new

    message = Fixtures.some_message

    assert_raises EventStore::Messaging::Writer::Error do
      writer.reply message
    end
  end
end
