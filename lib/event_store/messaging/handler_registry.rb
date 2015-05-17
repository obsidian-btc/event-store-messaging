module EventStore
  module Messaging
    module HandlerRegistry
      def handler_registry
        @handler_registry ||= Object.new.extend EventStore::Messaging::Registry
      end

      def register_message_classes(handler_message_registry)
        handler_message_registry.each do |message_class|
          unless self.message_registry.registered?(message_class)
            self.message_registry.register(message_class)
          end
        end
      end
    end
  end
end
