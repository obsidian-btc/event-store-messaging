module EventStore
  module Messaging
    module Stream
      class Reader
        class Error < StandardError; end

        dependency :subscription
        dependency :dispatcher

        def self.build
          new
        end

        def self.start
          raise NotImplementedError
          # start listening to receive data items
        end

        def read(data)
          message, stream_item = dispatcher.deserialize(data)

          unless message
            raise Error, "Unknown message type: \"#{data[:type]}\""
          end

          dispatcher.dispatch(message, stream_item)

          return message, stream_item
        end
      end
    end
  end
end
