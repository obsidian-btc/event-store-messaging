module EventStore
  module Messaging
    module MessageRegistry
      def message_registry
        @message_registry ||= Object.new.extend EventStore::Messaging::Registry
      end
    end
  end
end
