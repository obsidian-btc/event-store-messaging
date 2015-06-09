require_relative 'client_integration_init'

stream_name = EventStore::Client::HTTP::Controls::Write.!
subscription = EventStore::Client::HTTP::Vertx::Subscription.build stream_name

reader = EventStore::Messaging::Stream::Reader.build
reader.subscription = subscription

dispatcher = Fixtures.dispatcher
reader.dispatcher = dispatcher

stream_entries = []
reader.start do |stream_entry|
  reader.action.call stream_entry
  stream_entries << stream_entry
end

Vertx.set_timer(1_500) do
  logger(__FILE__).debug stream_entries.inspect
end
