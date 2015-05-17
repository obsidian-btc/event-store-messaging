# take item, deserialize its message

# stream reader
# - gets item raw
# - read_item(raw_item)

item_data = {

}

msg = Fixtures.some_message
msg.some_attribute = 'some value'

stream_item = EventStore::Messaging::Strea::Item.new

stream_item.type = "SomeMessage"
stream_item.data = { 'some_attribute' => 'some value' }

# item -> message
# item type string to actual class
# class is in dispatcher

# stream_reader.message_classes <- dispatcher.message_classes <- handler.message_classes

class StreamReader
  dependency :dispatcher
  attr_reader :message_classes

  def self.build(dispatcher)
    new.tap do |instance|
      instance.dispatcher = dispatcher
    end
  end

  def read(item)

  end
end

