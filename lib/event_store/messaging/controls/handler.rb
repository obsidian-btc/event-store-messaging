module EventStore
  module Messaging
    module Controls
      module Handler
        class SomeHandler
          include EventStore::Messaging::Handler
          include EventStore::Messaging::Controls::Message

          handle SomeMessage do |message|
            Telemetry::Logger.get(self).data message.inspect
          end
        end

        class HandlesHandledMessage
          include EventStore::Messaging::Handler
          include EventStore::Messaging::Controls::Message

          handle HandledMessage do |message|
            message.handlers << self.class
          end
        end

        class ConfiguredHandler
          include EventStore::Messaging::Handler

          attr_accessor :configured_dependencies

          def configure_dependencies
            self.configured_dependencies = true
          end
        end

        def self.example
          SomeHandler.new
        end
      end
    end
  end
end
