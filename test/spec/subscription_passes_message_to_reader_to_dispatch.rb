require_relative 'spec_init'

reader = EventStore::Messaging::Stream::Reader.new

Inclusion.! reader, :Instruments

subscription = EventStore::Client::HTTP::Subscription.new
reader.subscription = subscription

reader.configure_subscription_action

data = { data: { foo: 'bar' }}

reader.subscription.receive data

# puts reader.dispatcher.dispatched?(data[:data])

puts reader.read? data
