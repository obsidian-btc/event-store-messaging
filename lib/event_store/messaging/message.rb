module EventStore
  module Messaging
    module Message
      def self.included(cls)
        cls.send :include, Schema::DataStructure
        cls.extend Info
        cls.extend Build
      end

      attr_writer :metadata
      def metadata
        @metadata ||= Metadata.new
      end

      # TODO Delegate to metadata [Scott, Tue Jun 23 2015]
      def message_type
        self.class.message_type
      end

      # TODO Delegate to metadata [Scott, Tue Jun 23 2015]
      def message_name
        self.class.message_name
      end

      def ==(other)
        (
          to_h == other.to_h
        )
      end
      alias :eql :==

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
        def build(data=nil, metadata=nil)
          data ||= {}
          metadata ||= {}

          metadata[:type] = message_type
          metadata[:name] = message_name

          metadata = build_metadata(metadata)

          new.tap do |instance|
            set_attributes(instance, data)
            instance.metadata = metadata
          end
        end

        def linked(metadata)
          build(nil, metadata)
        end

        def set_attributes(instance, data)
          SetAttributes.! instance, data
        end

        def build_metadata(metadata)
          if metadata.nil?
            Metadata.new
          else
            Metadata.build(metadata.to_h)
          end
        end
      end
    end
  end
end
