=begin
- gets item raw from ES client
- reads the raw data
- converts the raw data to stream item instance
- converts the data section of the item to a message

- stream reader needs to know about the message types

- dispatcher or stream reader?
  - can dispatcher be given the es client's item?

class Dispatcher
  def deserialize_item(item_data)
    - item_data.type
    - find message for item_data.type

    item_type = item

    item = StreamItem.build item_data <- is just raw data at this point
  end

  def message_class(item_type_str)
  end
end

- start with item_data

=end
