require_relative './controls_init'

subject = EventStore::Messaging::Controls::StreamName
Controls.output subject, :example
Controls.output subject, :get
