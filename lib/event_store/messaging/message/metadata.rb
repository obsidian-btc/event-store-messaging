# TODO Causation id need to be set to previous message id [Scott, Tue Jun 23 2015]

module EventStore
  module Messaging
    module Message
      class Metadata
        include Schema::DataStructure

        attribute :event_id

        attribute :source_stream # from streamId in stream entry data
        def source_stream_id
          raise NotImplementedError
        end

        attribute :correlation_stream
        def correlation_stream_id
          raise NotImplementedError
        end

        attribute :causation_event_id
        attribute :causation_stream # source stream of previous
        def causation_stream_id
          raise NotImplementedError
        end

        attribute :reply_stream
        def reply_stream_id
          raise NotImplementedError
        end
      end
    end
  end
end
