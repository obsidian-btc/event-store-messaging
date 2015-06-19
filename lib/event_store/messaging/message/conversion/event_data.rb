module EventStore
  module Messaging
    module Message
      module Conversion
        module EventData
          def self.logger
            @logger ||= Telemetry::Logger.get self
          end

          def self.!(msg)
            logger.trace "Converting message to event data (Message Type: #{msg.message_type})"
            event_data = EventStore::EventData.new

            event_data.assign_id

            event_data.type = msg.message_type
            event_data.data = msg.to_h

            logger.debug "Converted message to event data (Message Type: #{msg.message_type})"

            event_data
          end
        end
      end
    end
  end
end
