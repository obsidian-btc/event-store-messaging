module EventStore
  module Messaging
    class Writer
      class Error < StandardError; end

      dependency :writer, EventStore::Client::HTTP::EventWriter
      dependency :logger, ::Telemetry::Logger
      dependency :telemetry, ::Telemetry

      def self.build(session: nil)
        logger.trace "Building"
        new.tap do |instance|
          EventStore::Client::HTTP::EventWriter.configure instance, session: session
          ::Telemetry::Logger.configure instance
          ::Telemetry.configure instance
          logger.debug "Built"
        end
      end

      def self.configure(receiver, session: nil)
        instance = build(session: session)
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

        telemetry.record :written, Telemetry::Data.new(stream_name, message)

        event_data
      end

      def event_data_batch(messages)
        messages = [messages] unless messages.is_a? Array

        batch = messages.map do |message|
          EventStore::Messaging::Message::Export::EventData.(message)
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

        telemetry.record :replied, Telemetry::Data.new(reply_stream_name, message)

        message
      end

      def self.logger
        @logger ||= ::Telemetry::Logger.get self
      end

      def self.register_telemetry_sink(writer)
        sink = Telemetry.sink
        writer.telemetry.register sink
        sink
      end

      module Telemetry
        class Sink
          include ::Telemetry::Sink

          record :written
          record :replied
        end

        Data = Struct.new :stream_name, :message

        def self.sink
          Sink.new
        end
      end

      class Substitute
        attr_accessor :stream_version

        dependency :writer
        dependency :telemetry, Telemetry

        def self.build
          new.tap do |instance|
            instance.writer = EventStore::Messaging::Writer.new
            ::Telemetry.configure instance
          end
        end

        def messages
          @messages ||= Hash.new do |hash, stream_name|
            hash[stream_name] = []
          end
        end

        def write(msg, stream_name, expected_version: nil, reply_stream_name: nil)
          if stream_version && expected_version && expected_version != stream_version
            raise EventStore::Client::HTTP::Request::Post::ExpectedVersionError
          end

          writer.write(msg, stream_name, reply_stream_name: reply_stream_name).tap do
            messages[stream_name] << msg
            telemetry.record :written, Telemetry::Data.new(stream_name, message)
          end
        end

        def reply(msg)
          reply_stream_name = msg.metadata.reply_stream_name
          result = writer.reply(msg)
          messages[reply_stream_name] << msg
          telemetry.record :replied, Telemetry::Data.new(reply_stream_name, message)
          msg
        end

        def written?(msg=nil, stream_name=nil, &predicate)
          if predicate.nil?
            predicate = Proc.new { |m| m == msg }
          end

          if stream_name
            messages[stream_name].any? &predicate
          else
            messages.each_key do |stream_name|
              return true if written? msg, stream_name, &predicate
            end
            false
          end
        end
      end
    end
  end
end
