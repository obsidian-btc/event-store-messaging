module EventStore
  module Messaging
    module Controls
      module Message
        class SomeMessage
          include EventStore::Messaging::Message

          attribute :some_attribute
          attribute :some_time
        end

        def self.attribute
          'some value'
        end

        def self.time(time=nil)
          time || ::Controls::Time.reference
        end

        def self.data(time=nil)
          {
            some_attribute: attribute,
            some_time: time(time)
          }
        end

        def self.example(time=nil, metadata: nil)
          time ||= time(time)
          metadata ||= EventStore::Messaging::Controls::Message::Metadata.example

          msg = SomeMessage.new
          msg.some_attribute = attribute
          msg.some_time = time

          msg.metadata = metadata

          msg
        end
      end
    end
  end
end
