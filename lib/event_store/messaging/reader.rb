module EventStore
  module Messaging
    class Reader < MessageReader
      def self.http_reader
        Client::HTTP::Reader
      end
    end
  end
end
