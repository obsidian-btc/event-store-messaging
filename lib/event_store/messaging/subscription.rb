module EventStore
  module Messaging
    class Subscription < MessageReader
      def self.http_reader
        Client::HTTP::Subscription
      end

      module Process
        def run(&blk)
          blk.(session.connection)
          start
        end
      end
    end
  end
end
