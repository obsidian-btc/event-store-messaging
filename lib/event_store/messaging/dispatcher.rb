module EventStore
  module Messaging
    module Dispatcher
      def self.included(cls)
        cls.extend Macro
        cls.extend MessageRegistry
        cls.extend HandlerRegistry
        cls.extend Deserialize
        cls.extend Build
      end

      module Macro
        def handler(handler_class)
          handler_registry.register(handler_class)
        end
      end

      module MessageRegistry
        def message_registry
          @message_registry ||= EventStore::Messaging::MessageRegistry.build
        end
      end

      module HandlerRegistry
        def handler_registry
          @handler_registry ||= build_handler_registry
        end

        def build_handler_registry
          handler_registry = EventStore::Messaging::HandlerRegistry.build
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

      module Deserialize
        class Error < StandardError; end

        def format(item_data)
          Casing::Hash::Underscore.! item_data
        end

        def deserialize(item_data)
          item_data = format(item_data)
          stream_item = Stream::Item.build(item_data)
          item_type = stream_item.type
          msg_class = message_registry.get(item_type)

          msg = nil
          if msg_class
            msg = msg_class.build(item_data)
          end

          return msg, stream_item
        end
      end

      module NullObject
        def self.build
          Substitute.new
        end
      end

      class Substitute
        include Dispatcher

        def deserialize(item_data)
          substitute_msg = Object.new.extend(EventStore::Messaging::Message)
          stream_item = Stream::Item.build(item_data)
          return substitute_msg, stream_item
        end

        def dispatch(message, stream_item)
          record = Struct.new(:message, :stream_item).new(message, stream_item)
          dispatches << record
        end

        def dispatches
          @dispatches ||= []
        end

        def dispatched?(item_data)
          dispatches.any? do |record|
            record.stream_item.data == item_data
          end
        end
      end

      def handlers
        self.class.handler_registry
      end

      def register_handler(handler_class)
        self.class.handler_registry.register(handler_class)
      end

      def deserialize(item_data)
        self.class.deserialize(item_data)
      end

      def dispatch(message, metadata)
        handlers.get(message).each do |handler_class|
          handler_class.! message, metadata
        end
      end
    end
  end
end
