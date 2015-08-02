module EventStore
  module Messaging
    module Controls
      module StreamName
        class Example
          include EventStore::Messaging::StreamName

          category 'someCategory'
        end

        def self.example
          Example.new
        end

        def self.get(category=nil, id=nil, random: nil)
          EventStore::Client::HTTP::Controls::StreamName.get category, id, random: random
        end

        def self.reference
          EventStore::Client::HTTP::Controls::StreamName.reference
        end
      end
    end
  end
end
