module EventStore
  module Messaging
    class Writer
      class Error < StandardError; end

      dependency :writer, EventStore::Client::HTTP::EventWriter
      dependency :logger, Telemetry::Logger

      def self.build
        logger.trace "Building"
        new.tap do |instance|
          EventStore::Client::HTTP::EventWriter.configure instance
          Telemetry::Logger.configure instance
          logger.debug "Built"
        end
      end

      def self.configure(receiver)
        instance = build
        receiver.writer = instance
        instance
      end

      def write(message, stream_name, reply_stream_name: nil, expected_version: nil)
        unless message.is_a? Array
          logger.trace "Writing (Message Type: #{message.message_type}, Stream Name: #{stream_name}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
        else
          logger.trace "Writing batch (Stream Name: #{stream_name}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
        end

        if reply_stream_name
          message.metadata.reply_stream_name = reply_stream_name
        end

        event_data = event_data_batch(message)

        writer.write(event_data, stream_name, expected_version: expected_version)

        unless message.is_a? Array
          logger.debug "Wrote (Message Type: #{message.message_type}, Stream Name: #{stream_name}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
        else
          logger.trace "Wrote batch (Stream Name: #{stream_name}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
        end

        event_data
      end

      def event_data_batch(messages)
        messages = [messages] unless messages.is_a? Array

        batch = messages.map do |message|
          EventStore::Messaging::Message::Export::EventData.! message
        end

        batch
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
        attr_accessor :stream_version
        attr_accessor :writer

        def self.build
          new.tap do |instance|
            instance.writer = EventStore::Messaging::Writer.new
          end
        end

        def messages
          @messages ||= []
        end

        def write(msg, stream_id, expected_version: nil, reply_stream_name: nil)
          if stream_version && expected_version && expected_version != stream_version
            raise EventStore::Client::HTTP::Request::Post::ExpectedVersionError
          end

          writer.write(msg, stream_id, reply_stream_name: reply_stream_name).tap do
            messages << msg
          end
        end

        def reply(msg)
          result = writer.reply(msg).tap do
            messages << msg
          end
        end

        def written?(msg)
          messages.include? msg
        end
      end
    end
  end
end
