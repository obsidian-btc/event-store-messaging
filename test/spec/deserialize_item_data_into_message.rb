require_relative 'spec_init'

describe "Deserialize Item Data" do
  specify "Message corresponding to the item type is built with the item's data" do
    item_data = Fixtures.item_data
    msg = Fixtures::SomeDispatcher.deserialize item_data
    assert(msg.is_a? Fixtures::SomeMessage)
  end
end

describe "Deserialize Item Data for an Unregistered Message" do
  specify "Is an error"
end


# include EventStore::Messaging

# puts
# puts "*****"

# puts
# puts "Deserialization"
# puts

# item_data = Fixtures.item_data

# stream_item = Stream::Item.build item_data

# puts "Stream Item"
# puts stream_item.id
# puts stream_item.type
# puts stream_item.version
# puts stream_item.stream_name
# puts stream_item.data

# msg_data = stream_item.data

# msg = Fixtures::SomeMessage.build msg_data

# puts "Message"
# puts msg.some_attribute

# dispatcher = Fixtures.dispatcher

# puts dispatcher.class.message_registry.inspect

# =begin
# -
# =end

# dispatcher.class.class_eval do
#   def self.deserialize(item_data)
#     item = Stream::Item.build(item_data)
#     item_type = item.type
#     msg_class = message_registry.get(item_type)
#     msg = msg_class.build item_data
#   end
# end

# msg = dispatcher.class.deserialize item_data

# puts msg.inspect
# puts msg.attributes.inspect




