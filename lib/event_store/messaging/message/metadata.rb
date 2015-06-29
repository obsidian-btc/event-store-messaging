module EventStore
  module Messaging
    module Message
      class Metadata
        include Schema::DataStructure

        attribute :event_id
        attribute :source_stream_name
        attribute :correlation_stream_name
        attribute :causation_event_id
        attribute :causation_stream_name
        attribute :reply_stream_name
        attribute :version

        def clear_reply_stream_name
          self.reply_stream_name = nil
        end
      end
    end
  end
end
