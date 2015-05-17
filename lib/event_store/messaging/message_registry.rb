module EventStore
  module Messaging
    module MessageRegistry
      def message_classes
        @message_classes ||= Object.new.extend EventStore::Messaging::Registry
      end
    end
  end
end
