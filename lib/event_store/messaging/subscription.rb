module EventStore
  module Messaging
    class Subscription < MessageReader
      def self.http_reader
        Client::HTTP::Subscription
      end

      module ProcessHostIntegration
        def change_connection_policy(policy)
          session.connection.policy = policy
        end
      end
    end
  end
end
