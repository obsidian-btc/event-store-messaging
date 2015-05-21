=begin

- fake subscription that i can send messages to,
and they get forwarded to the subscription's block

=end

require_relative 'spec_init'

reader = EventStore::Messaging::Stream::Reader.new
subscription = reader.subscription

subscription.extend subscription.class::Controls

controls = subscription.class::Controls
