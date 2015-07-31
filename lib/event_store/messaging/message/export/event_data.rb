module EventStore
  module Messaging
    module Message
      module Export
        module EventData
          def self.logger
            @logger ||= Telemetry::Logger.get self
          end

          def self.!(message)
            logger.trace "Converting message to event data (Message Type: #{message.message_type})"

            event_data = EventStore::Client::HTTP::EventData::Write.build

            event_data.assign_id
            event_data.type = message.message_type
            event_data.data = message.to_h

            event_data.metadata = Metadata.! message.metadata

            logger.debug "Converted message to event data (Message Type: #{message.message_type})"

            event_data
          end

          module Metadata
            def self.!(metadata)
              data = metadata.to_h
              data.delete :event_id

              data.delete_if { |k, v| v.nil? }

              data
            end
          end
        end
      end
    end
  end
end
