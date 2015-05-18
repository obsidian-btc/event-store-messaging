module EventStore
  module Messaging
    module Handler
      def self.included(cls)
        cls.extend Macro
        cls.extend MessageRegistry
        cls.extend Info
        cls.extend Build
      end

      module Macro
        def handle_macro(message_class, &blk)
          logger = Telemetry::Logger.get self

          logger.trace "Defining handler method (Message: #{message_class})"

          define_handler_method(message_class, &blk)
          message_registry.register(message_class)
        end
        alias :handle :handle_macro

        def define_handler_method(message_class, &blk)
          logger = Telemetry::Logger.get self

          handler_method_name = handler_name(message_class)
          send(:define_method, handler_method_name, &blk).tap do
            logger.debug "Defined handler method (Method Name: #{handler_method_name}, Message: #{message_class})"
          end
        end
      end

      module MessageRegistry
        def message_registry
          @message_registry ||= EventStore::Messaging::Registry.build
        end
      end

      module Info
        def handles?(message)
          method_defined? handler_name(message)
        end

        def handler_name(message)
          name = Message::Info.message_identifier(message)
          "handle_#{name}"
        end
      end

      module Build
        def build
          new
        end
      end

      def handle(message)
        handler = self.class.handler_name(message)
        send handler, message
      end
    end
  end
end
