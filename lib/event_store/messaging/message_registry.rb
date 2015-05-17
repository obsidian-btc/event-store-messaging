module EventStore
  module Messaging
    module MessageRegistry
      def message_registry
        @message_registry ||= EventStore::Messaging::Registry.build
      end
    end
  end
end
