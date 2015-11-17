module EventStore
  module Messaging
    module Message
      module Copy
        extend self

        def call(receiver, source, *attributes, exclude: nil)
          return SetAttributes.(receiver, source, include: attributes.flatten, exclude: exclude)
        end
      end
    end
  end
end
