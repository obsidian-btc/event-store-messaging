require_relative './message_init'

subject = EventStore::Messaging::Controls::Message

Controls.output subject, :data
Controls.output subject, :example
