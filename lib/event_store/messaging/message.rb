module EventStore
  module Messaging
    module Message
      def self.included(cls)
        cls.send :include, Schema
        cls.extend MessageInfo
        cls.extend Build
      end

      def message_name
        self.class.message_name
      end

      def message_identifier
        self.class.message_identifier
      end

      module MessageInfo
        def message_name(cls=self)
          cls.name.split('::').last
        end

        def message_identifier(cls=self)
          message_name(cls).gsub(/([^\^])([A-Z])/,'\1_\2').downcase
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
