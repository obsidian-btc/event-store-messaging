module EventStore
  module Messaging
    module Message
      module Copy
        extend self

        def call(receiver, source, include: nil, exclude: nil)
          return SetAttributes.(receiver, source, include: include, exclude: exclude)
        end
      end
    end
  end
end
