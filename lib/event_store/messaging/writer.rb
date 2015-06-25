module EventStore
  module Messaging
    class Writer
      dependency :writer, Client::HTTP::Vertx::Writer
      dependency :logger, Telemetry::Logger

      def self.build
        logger.trace "Building"
        new.tap do |instance|
          Client::HTTP::Vertx::Writer.configure instance
          Telemetry::Logger.configure instance
          logger.debug "Built"
        end
      end

      def self.configure(receiver)
        logger.trace "Configuring (Receiver: #{receiver.inspect})"

        instance = build

        receiver.writer = instance

        logger.debug "Configured (Receiver: #{receiver.inspect})"

        instance
      end

      def write(message, stream_name)
        logger.trace "Writing (Message Type: #{message.message_type})"

        # TODO Put reply_stream in metadata [Scott, Thu Jun 25 2015]
        event_data = EventStore::Messaging::Message::Conversion::EventData.! message

        writer.write stream_name, event_data
        logger.debug "Wrote (Message Type: #{message.message_type})"

        event_data
      end

      def self.logger
        @logger ||= Telemetry::Logger.get self
      end

      class Substitute
        def self.build
          new
        end

        def messages
          @messages ||= []
        end

        def write(msg, stream_id)
          messages << msg
          msg
        end

        def written?(msg)
          messages.include? msg
        end
      end
    end
  end
end
