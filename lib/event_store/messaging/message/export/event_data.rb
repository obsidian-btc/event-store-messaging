module EventStore
  module Messaging
    module Message
      module Export
        module EventData
          def self.logger
            @logger ||= Telemetry::Logger.get self
          end

          def self.!(message)
            logger.trace "Exporting event data to message (Message Type: #{message.message_type})"

            event_data = EventStore::Client::HTTP::EventData::Write.build

            event_data.assign_id
            event_data.type = message.message_type
            event_data.data = message.to_h

            event_data.metadata = Metadata.! message.metadata

            logger.debug "Exported event data to message (Message Type: #{message.message_type})"

            event_data
          end

          module Metadata
            def self.!(metadata)
              logger.trace "Converting message metadata to event data metadata"

              data = metadata.to_h
              data.delete :event_id

              data.delete_if { |k, v| v.nil? }

              logger.debug "Converted message metadata to event data metadata"

              data
            end
          end
        end
      end
    end
  end
end
