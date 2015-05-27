module EventStore
  module Client
    module HTTP
      class Subscription
        attr_accessor :action

        def self.configure(receiver)
        end

        def initialize
        end

        def start(&blk)
        end

        def receive(data)
          action.call data
        end
      end
    end
  end
end
