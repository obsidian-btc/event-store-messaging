module EventStore
  module Messaging
    class CategoryWriter
      attr_accessor :category_name

      dependency :writer, Client::HTTP::Vertx::Writer
      dependency :logger, Telemetry::Logger

      def initialize(category_name=nil)
        @category_name = category_name
      end

      def self.build(category_name=nil)
        logger.trace "Building (Category Name: #{category_name})"
        new(category_name).tap do |instance|
          Client::HTTP::Vertx::Writer.configure instance, category_name
          Telemetry::Logger.configure instance
          logger.debug "Built (Category Name: #{category_name})"
        end
      end

      def self.configure(receiver, category_name)
        logger.trace "Configuring (Receiver: #{receiver.inspect}, Category Name: #{category_name})"

        instance = build(category_name)

        receiver.writer = instance

        logger.debug "Configured (Receiver: #{receiver.inspect}, Category Name: #{category_name})"

        instance
      end

      def write(message, id, reply_stream: nil)
        logger.trace "Writing (#{abstract(message, id, reply_stream)})"

        stream_name = stream_name(id)

        # TODO Put reply_stream in metadata [Scott, Thu Jun 25 2015]
        event_data = EventStore::Messaging::Message::Conversion::EventData.! message

        writer.write stream_name, event_data
        logger.debug "Wrote (#{abstract(message, id, reply_stream)})"

        event_data
      end

      def stream_name(id)
        "#{category_name}-#{id}"
      end

      def abstract(message, id, reply_stream=nil)
        abstract = "Message Type: #{message.message_type}, Category Name: #{category_name}, ID: #{id}"
        abstract << " Reply Stream: #{reply_stream}" if reply_stream
        abstract
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

        def write(message, id, reply_stream: nil)
          # TODO Put metadata in recording of write [Scott, Thu Jun 25 2015]
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
