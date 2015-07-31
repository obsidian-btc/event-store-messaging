require_relative './message_init'

subject = EventStore::Messaging::Controls::Message::Metadata

Controls.output subject, :data
Controls.output subject, :example

subject = EventStore::Messaging::Controls::Message::Metadata::JSON

Controls.output subject, :data
