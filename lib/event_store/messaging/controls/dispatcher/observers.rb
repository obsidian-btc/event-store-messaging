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

          module Notification
            def self.example
              Messaging::Dispatcher::Observers::Notification.new message, event_data
            end

            def self.message
              Message.example
            end

            def self.event_data
              EventData::Read.example
            end
          end
        end
      end
    end
  end
end
