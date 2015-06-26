require_relative 'spec_init'

msg = SomeMessage.linked metadata

msg = SomeMessage.build { |metadata| metadata.copy(message.metadata) }


# ===


msg = SomeMessage.build do |metadata|
   metadata.initiate_stream(send_funds_stream_name)
end



msg = SomeMessage.linked metadata, :no_reply

msg = SomeMessage.linked metadata, :initiate_stream






msg = SomeMessage.build do |metadata_builder|
   metadata_builder.copy(previous_message.metadata)
   metadata_builder.no_reply

   metadata_builder.clear_reply
end

msg = SomeMessage.build do |metadata_builder|
   metadata_builder.copy(previous_message.metadata)
end

# - - -

reply_stream_name = previous_message.source_stream_name

writer.write msg, stream_name, reply: reply_stream_name


writer.write msg, stream_name, reply: nil


# ===


writer.write(msg, stream_name) do |write|
  write.reply(reply_stream_name)
end


# ===


reply_stream_name = previous_message.source_stream_name

msg = SomeMessage.build do |metadata_builder|
   metadata_builder.copy(previous_message.metadata)
   metadata_builder.reply(reply_stream_name)
end

# - - -

writer.write msg, stream_name

