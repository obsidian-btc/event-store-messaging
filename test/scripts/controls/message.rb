require_relative './controls_init'

subject = EventStore::Messaging::Controls::Message

Controls.output subject, :example
