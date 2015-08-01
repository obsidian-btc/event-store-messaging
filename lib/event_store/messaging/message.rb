module EventStore
  module Messaging
    module Message
      def self.included(cls)
        cls.send :include, Schema::DataStructure
        cls.extend Info
        cls.extend Build
        cls.extend Linked
        cls.extend Initial
      end

      attr_writer :metadata
      def metadata
        @metadata ||= Metadata.new
      end

      def message_type
        self.class.message_type
      end

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
          class_name
        end
      end

      module Build
        def build(data=nil, metadata=nil)
          data ||= {}
          metadata ||= {}

          metadata = build_metadata(metadata)

          new.tap do |instance|
            set_attributes(instance, data)
            instance.metadata = metadata
          end
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

      module Linked
        def linked(metadata)
          metadata = copy_metadata(metadata)
          build(nil, metadata)
        end

        def copy_metadata(other_metadata)
          metadata = Metadata.new

          metadata.causation_event_uri = other_metadata.source_event_uri
          metadata.correlation_stream_name = other_metadata.correlation_stream_name
          metadata.reply_stream_name = other_metadata.reply_stream_name

          metadata
        end
      end

      module Initial
        def initial(initiated_stream_name)
          metadata = Metadata.new
          metadata.correlation_stream_name = initiated_stream_name
          build(nil, metadata)
        end
      end
    end
  end
end
