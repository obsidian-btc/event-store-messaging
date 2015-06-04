require_relative 'client_integration_init'

stream_name = 'someStream'

subscription = EventStore::Client::HTTP::Vertx::Subscription.build stream_name

reader = EventStore::Messaging::Stream::Reader.build(subscription)

reader.start
