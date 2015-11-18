module EventStore
  module Messaging
    module Message
      module Proceed
        extend self

        def self.call(source, receiver=nil, include: nil, exclude: nil, strict: nil)
          proceed(source, receiver, include: include, exclude: exclude, strict: strict)
        end

        def proceed(source, receiver=nil, include: nil, exclude: nil, strict: nil)
          metadata = Metadata.new

          metadata.causation_event_uri = source.metadata.source_event_uri
          metadata.correlation_stream_name = source.metadata.correlation_stream_name
          metadata.reply_stream_name = source.metadata.reply_stream_name

          receiver.metadata = metadata

          receiver
        end
      end
    end
  end
end
