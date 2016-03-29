module EventStore
  module Messaging
    class Subscription < MessageReader
      def self.http_reader
        Client::HTTP::Subscription
      end

      module ProcessHostIntegration
        def change_connection_scheduler(scheduler)
          reader.change_connection_scheduler scheduler
        end

        def start
          loop do
            logger.trace "Starting subscription (Stream Name: #{stream_name.inspect})"
            super
            logger.debug "Subscription stopped (Stream Name: #{stream_name.inspect})"
          end
        end
      end
    end
  end
end
