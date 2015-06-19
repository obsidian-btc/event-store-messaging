module EventStore
  module Messaging
    class Writer
      attr_accessor :category_name

      dependency :writer, Client::HTTP::Vertx::Writer
      dependency :logger, Telemetry::Logger

      def initialize(category_name)
        @category_name = category_name
      end

      def self.build(category_name)
        logger.trace "Building (Category Name: #{category_name})"
        new(category_name).tap do |instance|
          Client::HTTP::Vertx::Writer.configure instance, category_name
          Telemetry::Logger.configure instance
          logger.debug "Built (Category Name: #{category_name})"
        end
      end

      def write(message)
        event_data = EventStore::Messaging::Message::Conversion::EventData.! message
        writer.! event_data
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

        def write(msg)
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
