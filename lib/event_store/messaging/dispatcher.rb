module EventStore
  module Messaging
    module Dispatcher
      def self.included(cls)
        cls.class_exec do
          extend HandlerMacro
          extend MessageRegistry
          extend HandlerRegistry
          extend BuildMessage
          extend Build
          extend Configure
          extend Logger

          dependency :logger, Telemetry::Logger
          dependency :observers, Observers
        end
      end

      module HandlerMacro
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
          new.tap do |instance|
            Telemetry::Logger.configure instance
            Observers.configure instance
          end
        end
      end

      module Configure
        def configure(receiver, attr_name: nil)
          attr_name ||= :dispatcher

          instance = build
          receiver.public_send "#{attr_name}=", instance
          instance
        end
      end

      module Logger
        def logger
          Telemetry::Logger.get self
        end
      end

      module BuildMessage
        def build_message(event_data)
          type = event_data.type

          logger.trace "Building message (Type: #{type})"

          message_class = message_registry.get(type)

          if message_class.nil?
            logger.debug "No message class registered (Type: #{type})"
            return nil
          end

          logger.debug "Building message (Class: #{message_class.name})"
          Message::Import::EventData.(event_data, message_class)
        end
      end

      def handlers
        self.class.handler_registry
      end

      def register_handler(handler_class)
        self.class.handler_registry.register(handler_class)
      end

      def build_message(entry_data)
        self.class.build_message(entry_data)
      end

      def dispatch(message, event_data)
        observers.notify :dispatching, message, event_data

        handlers.get(message).each do |handler_class|
          handler_class.(message, event_data)
        end

        observers.notify :dispatched, message, event_data

        nil

      rescue => error
        observers.notify :failed, message, event_data, error

        raise error
      end

      def dispatched(&observer)
        observers.dispatched &observer
      end

      def dispatching(&observer)
        observers.dispatching &observer
      end

      def failed(&observer)
        observers.failed &observer
      end

      def remove_observer(registration)
        observers.unregister registration
      end

      module Substitute
        def self.build
          Dispatcher.new
        end

        class Dispatcher
          def build_message(event_data)
            substitute_msg = Object.new.extend(EventStore::Messaging::Message)
            return substitute_msg
          end

          def dispatch(message, event_data)
            record = Struct.new(:message, :event_data).new(message, event_data)
            dispatches << record
          end

          def dispatches
            @dispatches ||= []
          end

          def dispatched?(entry_data)
            dispatches.any? do |record|
              record.event_data == entry_data
            end
          end
        end
      end
    end
  end
end
