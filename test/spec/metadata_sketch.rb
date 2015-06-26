require_relative 'spec_init'


source_stream_id = UUID.random
source_stream = "sourceStream-#{source_stream_id}"

correlation_stream_id = UUID.random
correlation_stream = "correlationStream-#{correlation_stream_id}"

causation_stream_id = UUID.random
causation_stream = "causationStream-#{causation_stream_id}"

reply_stream_id = UUID.random
reply_stream = "replyStream-#{reply_stream_id}"

metadata = EventStore::Messaging::Message::Metadata.new

metadata.source_stream = source_stream
metadata.correlation_stream = correlation_stream
metadata.causation_stream = causation_stream
metadata.reply_stream = reply_stream

puts metadata.inspect

class SomeMessage
  def self.build(&blk)
    new_metadata = EventStore::Messaging::Message::Metadata.new

    blk.call new_metadata

    # now metadata is changed
  end
end

SomeMessage.build do |metadata_builder|
   metadata_builder.set(previous_message.metadata)
   metadata_builder.no_reply
   metadata_builder.initiate
end

class MetadataBuilder
  attr_accessor :reply

  def reply
    @reply ||= true
  end

  def no_reply
    self.reply = true
  end

  def metadata
    m = EventStore::Messaging::Message::Metadata.new

    m
  end
end
