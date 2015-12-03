module EventStore
  module Messaging
    class Subscription < MessageReader
      def self.http_reader
        Client::HTTP::Subscription
      end

      module ProcessHostIntegration
        def change_connection_scheduler(scheduler)
          session.connection.scheduler = scheduler
        end
      end
    end
  end
end
