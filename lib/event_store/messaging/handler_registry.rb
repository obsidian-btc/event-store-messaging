module EventStore
  module Messaging
    class HandlerRegistry < Registry
      def get(message)
        items.select do |handler_class|
          handler_class.handles? message
        end
      end
    end
  end
end
