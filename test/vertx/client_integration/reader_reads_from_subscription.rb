require_relative 'client_integration_init'

stream_name = EventStore::Client::HTTP::Controls::Write.!
subscription = EventStore::Client::HTTP::Vertx::Subscription.build stream_name

reader = EventStore::Messaging::Stream::Reader.build
reader.subscription = subscription

dispatcher = Fixtures.dispatcher
reader.dispatcher = dispatcher

reader.start
