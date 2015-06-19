require_relative 'client_integration_init'

stream_name = EventStore::Client::HTTP::Controls::Write.!
subscription = EventStore::Client::HTTP::Vertx::Subscription.build stream_name

reader = EventStore::Messaging::Reader.build
reader.subscription = subscription

dispatcher = Fixtures.dispatcher
reader.dispatcher = dispatcher

stream_entries = []
intercept = Proc.new do |stream_entry|
  stream_entries << stream_entry
end

reader.start &intercept

Vertx.set_timer(1_500) do
  assert(stream_entries.length == 1)
  assert(stream_entries[0].type == "SomeEvent")

  logger(__FILE__).data stream_entries.inspect
end
