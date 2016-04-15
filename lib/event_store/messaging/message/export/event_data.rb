module EventStore
  module Messaging
    module Message
      module Export
        module EventData
          def self.logger
            @logger ||= Telemetry::Logger.get self
          end

          def self.call(message)
            logger.opt_trace "Exporting event data to message (Message Type: #{message.message_type})"

            event_data = EventStore::Client::HTTP::EventData::Write.build

            event_data.assign_id
            event_data.type = message.message_type
            event_data.data = message.to_h

            event_data.metadata = Metadata.(message.metadata)

            logger.opt_debug "Exported event data to message (Message Type: #{message.message_type})"

            event_data
          end
          class << self; alias :! :call; end # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

          module Metadata
            def self.call(metadata)
              logger.opt_trace "Converting message metadata to event data metadata"

              data = metadata.to_h
              data.delete :event_id

              data.delete_if { |k, v| v.nil? }

              logger.opt_debug "Converted message metadata to event data metadata"

              data
            end
            class << self; alias :! :call; end # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

            def self.logger
              Telemetry::Logger.get self
            end
          end
        end
      end
    end
  end
end
