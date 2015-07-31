require_relative './controls_init'

subject = EventStore::Messaging::Controls::Handler
Controls.output subject, :example
