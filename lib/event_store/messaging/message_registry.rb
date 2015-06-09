module EventStore
  module Messaging
    class MessageRegistry # < Registry
      include Registry

      def get(message_type)
        items.find do |message_class|
          message_class.message_type == message_type
        end
      end
    end
  end
end
