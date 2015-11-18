module EventStore
  module Messaging
    module Message
      class Metadata
        include Schema::DataStructure

        attribute :source_event_uri
        attribute :causation_event_uri
        attribute :correlation_stream_name
        attribute :reply_stream_name
        attribute :schema_version

        def clear_reply_stream_name
          self.reply_stream_name = nil
        end

        def precedence?(other_metadata)
          causation_event_uri == other_metadata.source_event_uri &&
            correlation_stream_name == other_metadata.correlation_stream_name &&
            reply_stream_name == other_metadata.reply_stream_name
        end
      end
    end
  end
end
