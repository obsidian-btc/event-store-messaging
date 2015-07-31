module EventStore
  module Messaging
    module Message
      class Metadata
        include Schema::DataStructure

        attribute :causation_event_uri
        attribute :correlation_stream_name
        attribute :reply_stream_name
        attribute :schema_version

        def clear_reply_stream_name
          self.reply_stream_name = nil
        end

        def serialize
          raise NotImplementedError
        end
      end
    end
  end
end
