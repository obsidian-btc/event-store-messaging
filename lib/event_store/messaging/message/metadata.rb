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
      end
    end
  end
end
