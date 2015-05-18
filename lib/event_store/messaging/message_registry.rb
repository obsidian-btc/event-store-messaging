module EventStore
  module Messaging
    class MessageRegistry < Registry
      def get(message_name)
        find do |message_class|
          message_class.message_name == message_name
        end
      end
    end
  end
end
