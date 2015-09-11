module EventStore
  module Messaging
    class Subscription::Process
      def self.build(stream_name, dispatcher)
        session = Client::HTTP::Session.build
        subscription = Subscription.build stream_name, dispatcher, session: session

        instance = new subscription, session
        Telemetry::Logger.configure instance
        instance
      end

      attr_reader :session
      attr_reader :subscription

      dependency :logger

      def initialize(subscription, session)
        @session = session
        @subscription = subscription
      end

      def start(io)
        session.connector = ->{io}
        logger.info "Starting subscription"
        subscription.start
      end

      def connect
        socket = session.connect
        logger.pass "Established connection: #{socket.inspect}"
        yield socket if block_given?
      end
    end
  end
end
