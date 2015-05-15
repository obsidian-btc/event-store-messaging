module Messaging
  module Dispatcher
    def self.included(cls)
      cls.extend Macro
      cls.extend Info
      cls.extend Build
    end

    module Macro
      def handler(handler_class)
        handlers << handler_class
      end
    end

    module Info
      def handlers
        @handlers ||= []
      end
    end

    module Build
      def build
        new
      end
    end

    def handlers
      self.class.handlers
    end

    def dispatch(message)
      handles(message).each do |handler_class|
        handler_class.build.handle message
      end
    end

    def handles(message)
      self.class.handlers.select do |handler_class|
        message_class_name = message.class.name.split('::').last
        handler_class.handles? message_class_name
      end
    end

    class Concrete
      include Dispatcher
    end
  end
end
