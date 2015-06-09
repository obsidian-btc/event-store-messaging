module EventStore
  module Messaging
    module Message
      module Conversion
        module StreamEntry
          def self.logger
            Telemetry::Logger.get self
          end

          def self.!(msg)
            stream_entry = EventStore::Stream::Entry.new

            stream_entry.type = msg.message_type
            stream_entry.data = msg.to_h

            stream_entry
          end
        end
      end
    end
  end
end
