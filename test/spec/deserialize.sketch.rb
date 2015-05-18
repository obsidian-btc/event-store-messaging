require_relative 'spec_init'

include EventStore::Messaging

puts
puts "*****"

puts
puts "Deserialization"
puts

item_data = Fixtures.item_data

stream_item = Stream::Item.build item_data

puts "Stream Item"
puts stream_item.id
puts stream_item.type
puts stream_item.version
puts stream_item.stream_name
puts stream_item.data

msg_data = stream_item.data

msg = Fixtures::SomeMessage.build msg_data

puts "Message"
puts msg.some_attribute

dispatcher = Fixtures.dispatcher

puts dispatcher.class.message_registry.inspect

=begin
-
=end

dispatcher.class.class_eval do
  def self.deserialize(item_data)
    item = Stream::Item.build(item_data)
    item_type = item.type
    msg_class = message_registry.find do |message_class|
      message_class.message_name == item_type
    end
  end
end

dispatcher.class.deserialize item_data




