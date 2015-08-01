module EventStore
  module Messaging
    module Controls
      module Registry
        class SomeRegistry
          include EventStore::Messaging::Registry
        end

        def self.example
          SomeRegistry.new
        end
      end
    end
  end
end
