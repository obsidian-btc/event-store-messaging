module EventStore
  module Messaging
    module MessageRegistry
      def message_classes
        @message_classes ||= Object.new.extend EventStore::Messaging::Registry
      end

      def message_registered?(message_class)
        message_classes.registered? message_class
      end

      def register_message_class(message_class)
        logger = Telemetry::Logger.get self

        logger.trace "Registering message class: #{message_class}"

        unless message_registered?(message_class)
          message_classes.register(message_class)
          logger.debug "Registered message class: #{message_class}"
        else
          logger.debug "Message class: #{message_class} is already registered. It was not registered again."
        end

        message_classes
      end
    end
  end
end
