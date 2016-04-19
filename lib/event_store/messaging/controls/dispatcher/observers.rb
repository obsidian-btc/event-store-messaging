module EventStore
  module Messaging
    module Controls
      module Dispatcher
        module Observers
          module Event
            def self.example
              :some_event
            end

            def self.unique
              Identifier::UUID::Random.get
            end
          end
        end
      end
    end
  end
end
