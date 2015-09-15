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

      def run(&blk)
        blk.call(session.connection) if block_given?
        logger.info "Starting subscription"
        subscription.start
      end
    end
  end
end
