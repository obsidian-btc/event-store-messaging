module EventStore
  module Messaging
    class Reader
      attr_reader :stream_name

      dependency :reader, EventStore::Client::HTTP::EventReader
      dependency :dispatcher, EventStore::Messaging::Dispatcher
      dependency :logger, Telemetry::Logger

      def starting_position
        @starting_position ||= 0
      end

      def slice_size
        @slice_size ||= 20
      end

      def initialize(stream_name, starting_position=nil, slice_size=nil)
        @stream_name = stream_name
        @starting_position = starting_position
        @slice_size = slice_size
      end

      def self.build(stream_name, dispatcher, starting_position: nil, slice_size: nil)
        logger.trace "Building event reader"

        new(stream_name, starting_position, slice_size).tap do |instance|
          EventStore::Client::HTTP::EventReader.configure instance, stream_name, starting_position: starting_position, slice_size: slice_size
          Telemetry::Logger.configure instance

          instance.dispatcher = dispatcher

          logger.debug "Built event reader"
        end
      end

      def read(&supplemental_action)
        logger.trace "Reading messages (Stream Name: #{stream_name})"

        reader.read do |event_data|
          message = dispatch(event_data)

          supplemental_action.call(message, event_data) if !!supplemental_action
        end

        logger.debug "Read messages (Stream Name: #{stream_name})"
        nil
      end

      def dispatch(event_data)
        logger.trace "Dispatching event data (Type: #{event_data.type})"
        logger.data event_data.inspect

        message = dispatcher.build_message(event_data)

        if !!message
          dispatcher.dispatch(message, event_data)
        else
          logger.debug "Cannot dispatch \"#{event_data.type}\". The \"#{dispatcher}\" dispatcher has no handlers that handle it."
        end

        logger.debug "Dispatched event data (Type: #{event_data.type})"

        message
      end

      def self.logger
        Telemetry::Logger.get self
      end
    end
  end
end
