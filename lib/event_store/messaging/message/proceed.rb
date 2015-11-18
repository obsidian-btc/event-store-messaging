module EventStore
  module Messaging
    module Message
      module Proceed
        extend self

        def self.call(source, receiver=nil, copy: nil, include: nil, exclude: nil, strict: nil)
          proceed(source, receiver, copy: copy, include: include, exclude: exclude, strict: strict)
        end

        def proceed(source, receiver=nil, copy: nil, include: nil, exclude: nil, strict: nil)
          unless include.nil? && exclude.nil?
            copy = true
          end

          copy ||= false

          if receiver.nil?
            receiver = self
          end

          if receiver.class == Class
            if receiver.method_defined? :build
              receiver = receiver.build
            else
              receiver = receiver.new
            end
          end

          source_metadata = nil
          if source.is_a? Metadata
            source_metadata = source
          else
            source_metadata = source.metadata
          end

          metadata = Metadata.new
          metadata.causation_event_uri = source_metadata.source_event_uri
          metadata.correlation_stream_name = source_metadata.correlation_stream_name
          metadata.reply_stream_name = source_metadata.reply_stream_name

          receiver.metadata = metadata

          if copy
            Copy.(source, receiver, include: include, exclude: exclude, strict: strict)
          end

          receiver
        end
      end
    end
  end
end
