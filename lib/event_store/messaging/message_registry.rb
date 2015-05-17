module EventStore
  module Messaging
    module MessageRegistry
      def message_classes
        @message_classes ||= []
      end

      def message_registered?(message_class)
        message_classes.include? message_class
      end

      def register_message_class(message_class)
        logger = Telemetry::Logger.get self

        logger.trace "Registering message class: #{message_class}"

        unless message_registered?(message_class)
          message_classes.push(message_class)
          logger.debug "Registered message class: #{message_class}"
        else
          logger.debug "Message class: #{message_class} is already registered. Not registered again."
        end

        message_classes
      end
    end
  end
end
