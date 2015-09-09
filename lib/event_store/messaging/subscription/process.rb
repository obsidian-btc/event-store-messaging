module EventStore
  module Messaging
    class Subscription::Process
      def self.build(stream_name, dispatcher)
        client = Client::HTTP::Client.build
        Telemetry::Logger.configure client

        request = Client::HTTP::Request::Get.build client
        Telemetry::Logger.configure request

        start_uri = Client::HTTP::StreamReader::Continuous.slice_path stream_name, 0, 20
        stream_reader = Client::HTTP::StreamReader::Continuous.new start_uri
        Telemetry::Logger.configure stream_reader
        stream_reader.request = request

        event_reader = Client::HTTP::Subscription.new stream_name
        Telemetry::Logger.configure event_reader
        event_reader.stream_reader = stream_reader
        event_reader.request = request

        subscription = Subscription.new stream_name
        Telemetry::Logger.configure subscription
        subscription.dispatcher = dispatcher
        subscription.reader = event_reader

        instance = new subscription, client
        Telemetry::Logger.configure instance
        instance
      end

      attr_reader :client
      attr_reader :subscription

      dependency :logger

      def initialize(subscription, client)
        @client = client
        @subscription = subscription
      end

      def start(io)
        client.socket = io
        logger.info "Starting subscription"
        subscription.start
      end

      def connect(io)
        client.establish_connection io
        logger.info "Established connection: #{io.socket.inspect}"
      end
    end
  end
end
