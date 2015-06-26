# TODO Causation id need to be set to previous message id [Scott, Tue Jun 23 2015]

module EventStore
  module Messaging
    module Message
      class Metadata
        include Schema::DataStructure

        attribute :event_id
        attribute :source_stream_name # from streamId in stream entry data
        attribute :correlation_stream_name
        attribute :causation_event_id
        attribute :causation_stream_name # source stream of previous
        attribute :reply_stream_name

        def source_stream_id
          raise NotImplementedError
        end

        def correlation_stream_id
          raise NotImplementedError
        end

        def causation_stream_id
          raise NotImplementedError
        end

        def reply_stream_id
          raise NotImplementedError
        end
      end
    end
  end
end
