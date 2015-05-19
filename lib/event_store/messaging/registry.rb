module EventStore
  module Messaging
    module Registry
      class Error < StandardError; end

      def self.included(cls)
        cls.extend Build
      end

      module Build
        def build
          new
        end
      end

      attr_accessor :after_register_hook

      def register(item)
        logger = Telemetry::Logger.get self

        logger.trace "Registering #{item}"

        if registered?(item)
          raise Error, "#{item} is already registered"
        end

        items.push(item)

        if after_register_hook
          after_register_hook.call item
        end

        items
      end

      def after_register(&blk)
        self.after_register_hook = blk
      end

      def registered?(item)
        items.include? item
      end

      def each
        items.each do |i|
          yield i
        end
      end

      def length
        items.length
      end

      protected
      def items
        @items ||= []
      end
    end
  end
end
