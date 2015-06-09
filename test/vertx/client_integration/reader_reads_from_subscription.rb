require_relative 'client_integration_init'

stream_name = EventStore::Client::HTTP::Controls::Write.!
subscription = EventStore::Client::HTTP::Vertx::Subscription.build stream_name

reader = EventStore::Messaging::Stream::Reader.build
reader.subscription = subscription

dispatcher = Fixtures.dispatcher
reader.dispatcher = dispatcher

stream_entries = []
probe = Proc.new do |stream_entry|
  stream_entries << stream_entry
end

reader.start &probe

Vertx.set_timer(1_500) do
  assert(stream_entries.length == 1)
  assert(stream_entries[0].type == "SomeEvent")

  logger(__FILE__).debug stream_entries.inspect
end
