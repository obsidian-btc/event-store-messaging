module EventStore
  module Messaging
    module Handler
      def self.included(base)
        base.extend Macro
        base.extend MessageRegistry
        base.extend Info
        base.extend Build
      end

      def handle(message)
        handler = self.class.handler_name(message)
        send handler, message
      end

      module Macro
        def handle_macro(message_class, &blk)
          logger = Telemetry::Logger.get self

          logger.trace "Defining handler method (Message: #{message_class})"

          register_message_class(message_class)

          handler_method_name = handler_name(message_class)
          send(:define_method, handler_method_name, &blk).tap do
            logger.debug "Defined handler method (Method Name: #{handler_method_name}, Message: #{message_class})"
          end
        end
        alias :handle :handle_macro
      end

      module Info
        def handles?(message)
          method_defined? handler_name(message)
        end

        def handler_name(message)
          name = MessageInfo.message_symbol(message)
          "handle_#{name}"
        end

        module MessageInfo
          def self.message_symbol(message)
            class_name = nil
            class_name = message if message.instance_of? String
            class_name ||= message.name if message.instance_of? Class
            class_name ||= message.class.name

            type = message_class(class_name)
            box_case(type).downcase
          end

          def self.message_class(name)
            name.split('::').last
          end

          def self.box_case(str)
            str.gsub(/([^\^])([A-Z])/,'\1_\2')
          end
        end
      end

      module Build
        def build
          new
        end
      end
    end
  end
end
