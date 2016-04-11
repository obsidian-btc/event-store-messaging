module EventStore
  module Messaging
    module Controls
      module Handler
        class SomeHandler
          include EventStore::Messaging::Handler
          include EventStore::Messaging::Controls::Message

          handle SomeMessage do |message, event_data|
            logger.data message.inspect
            logger.data event_data.inspect
          end
        end

        class OtherHandler < SomeHandler
        end

        class AnotherHandler
          include EventStore::Messaging::Handler
          include EventStore::Messaging::Controls::Message

          handle AnotherMessage do |message|
            Telemetry::Logger.get(self).data message.inspect
          end
        end

        class HandlesHandledMessage
          include EventStore::Messaging::Handler
          include EventStore::Messaging::Controls::Message

          handle HandledMessage do |message|
            message.handlers << self.class.name.split('::').last
          end
        end

        class ChangesEventData
          include EventStore::Messaging::Handler
          include EventStore::Messaging::Controls::Message

          handle SomeMessage do |message, event_data|
            event_data.data[:some_side_effect] = 1
          end
        end

        class ConfiguredHandler
          include EventStore::Messaging::Handler

          attr_accessor :configured_dependencies

          def configure_dependencies
            self.configured_dependencies = true
          end
        end

        class FailsWhenHandlingMessage
          include EventStore::Messaging::Handler
          include EventStore::Messaging::Controls::Message

          handle SomeMessage do
            fail
          end
        end

        def self.example
          SomeHandler.new
        end
      end
    end
  end
end
