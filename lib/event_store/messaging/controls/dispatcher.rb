module EventStore
  module Messaging
    module Controls
      module Dispatcher
        class SomeDispatcher
          include EventStore::Messaging::Dispatcher
          include EventStore::Messaging::Controls::Handler

          handler SomeHandler
          handler OtherHandler
          handler AnotherHandler
        end

        class DispatcherHandlesHandledMessage
          include EventStore::Messaging::Dispatcher
          include EventStore::Messaging::Controls::Handler

          handler HandlesHandledMessage
          handler SomeHandler
        end

        def self.example
          SomeDispatcher.new
        end

        def self.dispatcher_class
          SomeDispatcher
        end
      end
    end
  end
end
