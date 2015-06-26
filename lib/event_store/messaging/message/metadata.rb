# TODO Causation id need to be set to previous message id [Scott, Tue Jun 23 2015]

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
      end
    end
  end
end
