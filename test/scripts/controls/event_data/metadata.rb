require_relative './event_data_init'

subject = EventStore::Messaging::Controls::EventData::Metadata

Controls.output subject, :data
Controls.output subject, :example
