module EventStore
  module Messaging
    module Stream
      class Reader
        class Error < StandardError; end

        dependency :subscription
        dependency :dispatcher
        dependency :logger

        def self.build
          new().tap do |instance|
            EventStore::Client::HTTP::Subscription.configure instance
          end
        end

        def self.start
          instance = build
          instance.start
        end

        def start
          this = self
          subscription.start do |stream_item_data|
            this.read(stream_item_data)
          end
        end

        def read(data)
          message, stream_item = dispatcher.deserialize(data)

          if message
            dispatcher.dispatch(message, stream_item)
          else
            logger.debug "Cannot dispatch \"#{stream_item.type}\". The \"#{dispatcher}\" dispatcher has no handlers for it."
          end

          return message, stream_item
        end
      end
    end
  end
end
