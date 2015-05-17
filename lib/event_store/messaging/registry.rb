module EventStore
  module Messaging
    module Registry
      class Error < StandardError; end

      def registered?(item)
        items.include? item
      end

      def register(item)
        logger = Telemetry::Logger.get self

        logger.trace "Registering #{item}"

        if registered?(item)
          raise Error, "#{item} is already registered"
        end

        items.push(item)
      end

      private
      def items
        @items ||= []
      end
    end
  end
end
