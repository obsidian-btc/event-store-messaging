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

          def reply
            @reply ||= true
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
              metadata.correlation_stream = initiated_stream_name
            else
              copy(metadata)
            end

            metadata
          end

          # def clear(metadata)
          #   metadata.source_stream = nil
          #   metadata.causation_event_id = nil
          #   metadata.causation_stream = nil
          #   metadata.reply_stream = nil
          # end

          def copy(metadata)
            data = other_metadata.to_h rescue {}

            data.delete :event_id

            SetAttributes.! metadata, data

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
