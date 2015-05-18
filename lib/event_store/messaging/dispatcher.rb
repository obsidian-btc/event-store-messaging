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
        end
      end

      module MessageRegistry
        def message_registry
          # @message_registry ||= EventStore::Messaging::Registry.build
          @message_registry ||= EventStore::Messaging::MessageRegistry.build
        end
      end

      module HandlerRegistry
        def handler_registry
          @handler_registry ||= build_handler_registry
        end

        def build_handler_registry
          handler_registry = EventStore::Messaging::Registry.build
          this = self
          handler_registry.after_register do |handler_class|
            this.register_message_classes(handler_class.message_registry)
          end
          handler_registry
        end

        def register_message_classes(handler_message_registry)
          handler_message_registry.each do |message_class|
            unless self.message_registry.registered?(message_class)
              self.message_registry.register(message_class)
            end
          end
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
        message_handlers(message).each do |handler_class|
          handler_class.! message
        end
      end

      def message_handlers(message)
        self.class.handler_registry.select do |handler_class|
          handler_class.handles? message
        end
      end

      class Concrete
        include Dispatcher
      end
    end
  end
end
