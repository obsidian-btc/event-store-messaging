module EventStore
  module Messaging
    module Message
      class Metadata
        class Builder
          attr_writer :other_metadata
          attr_accessor :initiated_stream_name
          attr_writer :reply

          def other_metadata
            @other_metadata ||= Metadata.new
          end

          def reply?
            @reply = true if @reply.nil?
            @reply
          end

          def set(other_metadata)
            self.other_metadata = other_metadata
          end

          def initiate_stream(stream_name)
            self.initiated_stream_name = stream_name
          end

          def no_reply
            self.reply = false
          end

          def get
            metadata = Metadata.new

            if initiated?
              metadata.correlation_stream_name = initiated_stream_name
            else
              copy(metadata)
            end

            unless reply?
              metadata.reply_stream_name = nil
            end

            metadata
          end

          def copy(metadata)
            metadata.causation_event_id = other_metadata.event_id
            metadata.causation_stream_name = other_metadata.source_stream_name
            metadata.correlation_stream_name = other_metadata.correlation_stream_name
            metadata.reply_stream_name = other_metadata.reply_stream_name

            metadata
          end

          def initiated?
            !initiated_stream_name.nil?
          end
        end
      end
    end
  end
end
