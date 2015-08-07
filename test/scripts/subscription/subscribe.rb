require_relative './subscription_init'

stream_name = nil
begin
  stream_name = File.read "tmp/stream_name"
rescue
  raise "Stream name file is missing (tmp/stream_name). It's created by the write_events_periodically.rb script, which must be run concurrently with #{__FILE__}."
end

dispatcher = EventStore::Messaging::Controls::Dispatcher::BasicDispatcher.new
dispatcher.class.handler EventStore::Messaging::Controls::Handler::SomeHandler

reader = EventStore::Messaging::Subscription.build stream_name, dispatcher, slice_size: 1

reader.start do |message|
  logger(__FILE__).info message.inspect
end
