module EventStore
  module Messaging
    class Writer
      class Error < StandardError; end

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
        logger.trace "Writing (Message Type: #{message.message_type}, Stream Name: #{stream_name})"

        event_data = EventStore::Messaging::Message::Conversion::EventData.! message

        writer.write stream_name, event_data
        logger.debug "Wrote (Message Type: #{message.message_type}, Stream Name: #{stream_name})"

        event_data
      end

      def reply(message)
        metadata = message.metadata
        reply_stream_name = metadata.reply_stream_name

        logger.trace "Replying (Message Type: #{message.message_type}, Stream Name: #{reply_stream_name})"

        unless reply_stream_name
          error_msg = "Message has no reply stream name. Cannot reply. (Message Type: #{message.message_type})"
          logger.error error_msg
          raise Error, error_msg
        end

        metadata.clear_reply_stream_name

        write message, reply_stream_name

        logger.debug "Replied (Message Type: #{message.message_type}, Stream Name: #{reply_stream_name})"

        message
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
