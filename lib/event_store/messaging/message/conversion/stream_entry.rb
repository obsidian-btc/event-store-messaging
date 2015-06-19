module EventStore
  module Messaging
    module Message
      module Conversion
        module StreamEntry
          def self.!(msg)
            logger.trace "Converting message to stream entry (Message Type: #{msg.message_type})"

            stream_entry = EventStore::Stream::Entry.new

            stream_entry.type = msg.message_type
            stream_entry.data = msg.to_h

            logger.debug "Converted message to stream entry (Message Type: #{msg.message_type})"

            stream_entry
          end

          def self.logger
            @logger ||= Telemetry::Logger.get self
          end
        end
      end
    end
  end
end
