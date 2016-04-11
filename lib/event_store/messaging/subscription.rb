module EventStore
  module Messaging
    class Subscription < MessageReader
      def self.http_reader
        Client::HTTP::Subscription
      end
    end
  end
end
