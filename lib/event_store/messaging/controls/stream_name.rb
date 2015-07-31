module EventStore
  module Messaging
    module Controls
      module StreamName
        def self.reference
          EventStore::Client::HTTP::Controls::StreamName.reference
        end
      end
    end
  end
end
