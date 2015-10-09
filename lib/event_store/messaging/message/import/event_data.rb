module EventStore
  module Messaging
    module Message
      module Import
        module EventData
          def self.logger
            @logger ||= Telemetry::Logger.get self
          end

          def self.call(event_data, message_class)
            logger.trace "Importing event data to message (Message Class: #{message_class})"

            metadata = EventStore::Messaging::Message::Metadata.build event_data.metadata

            message_class.build(event_data.data).tap do |instance|
              instance.metadata = metadata

              logger.data event_data.inspect
              logger.data instance.inspect

              logger.debug "Imported event data to message (Message Class: #{message_class})"
            end
          end
          class << self; alias :! :call; end # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]
        end
      end
    end
  end
end
