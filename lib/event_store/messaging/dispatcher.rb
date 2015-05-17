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
          register_handler(handler_class)
        end
      end

      module HandlerRegistry
        def handlers
          @handlers ||= []
        end

        def register_handler(handler_class)
          handlers << handler_class
          register_message_classes(handler_class.message_classes)
        end

        def register_message_classes(message_classes)
          message_classes.each { |message_class| register_message_class(message_class) }
        end
      end

      module Build
        def build
          new
        end
      end

      def handlers
        self.class.handlers
      end

      def register_handler(handler_class)
        self.class.register_handler(handler_class)
      end

      def dispatch(message)
        handles(message).each do |handler_class|
          handler_class.build.handle message
        end
      end

      def handles(message)
        self.class.handlers.select do |handler_class|
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
