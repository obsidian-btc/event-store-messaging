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
        def build(data=nil, metadata=nil, &blk)
          data ||= {}
          metadata ||= {}

          metadata = build_metadata(metadata)

          blk.call(metadata) if block_given?

          new.tap do |instance|
            set_attributes(instance, data)
            instance.metadata = metadata
          end
        end

        def linked(metadata)
          # Note: metadata should have been a named arg,
          # but Ruby binds hashes strangely when the first
          # arg is nilable and the second arg is a nilable
          # named arg
          # [Scott, Thu Jun 25 2015]
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
