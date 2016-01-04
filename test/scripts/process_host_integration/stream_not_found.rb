require_relative './process_host_integration_init'

# When using the process host integration, a subscription to a non existent
# stream should loop indefinitely until the category stream comes into
# existence.

stream_name = EventStore::Messaging::Controls::StreamName.get 'testStreamNotFound'

dispatcher = EventStore::Messaging::Controls::Dispatcher.unique
dispatcher.register_handler EventStore::Messaging::Controls::Handler::SomeHandler

reader = EventStore::Messaging::Subscription.build stream_name, dispatcher

cooperation = ProcessHost::Cooperation.build
cooperation.register reader, 'stream-reader'
cooperation.start

fail 'Process should run indefinitely!'
