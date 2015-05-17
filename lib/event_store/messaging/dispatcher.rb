module EventStore
  module Messaging
    module Dispatcher
      def self.included(cls)
        cls.extend Macro
        cls.extend MessageRegistry
        cls.extend HandlerRegistry
        cls.extend Build
      end

      module Macro
        def handler(handler_class)
          handler_registry.register(handler_class)
          register_message_classes(handler_class.message_registry)
        end
      end

      module Build
        def build
          new
        end
      end

      def handlers
        self.class.handler_registry
      end

      def register_handler(handler_class)
        self.class.handler_registry.register(handler_class)
      end

      def dispatch(message)
        handles(message).each do |handler_class|
          handler_class.build.handle message
        end
      end

      def handles(message)
        self.class.handler_registry.select do |handler_class|
          message_class_name = message.class.name.split('::').last
          handler_class.handles? message_class_name
        end
      end

      class Concrete
        include Dispatcher
      end
    end
  end
end
