module EventStore
  module Messaging
    module Message
      def self.included(cls)
        cls.send :include, DataStructure
        cls.extend Info
        cls.extend Build
      end

      def message_type
        self.class.message_type
      end

      def message_name
        self.class.message_name
      end

      module Info
        extend self

        def message_type(msg=self)
          class_name(msg).split('::').last
        end

        def message_name(msg=self)
          message_type(msg).gsub(/([^\^])([A-Z])/,'\1_\2').downcase
        end

        def class_name(message)
          class_name = nil
          class_name = message if message.instance_of? String
          class_name ||= message.name if message.instance_of? Class
          class_name ||= message.class.name
        end
      end

      module Build
        def build(data=nil)
          data ||= {}
          new.tap do |instance|
            set_attributes(instance, data)
          end
        end

        def set_attributes(instance, data)
          SetAttributes.! instance, data
        end
      end
    end
  end
end
