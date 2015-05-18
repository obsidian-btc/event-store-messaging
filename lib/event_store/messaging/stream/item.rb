module EventStore
  module Messaging
    module Stream
      class Item
        include DataStructure

        attribute :id
        attribute :type
        attribute :version
        attribute :stream_name
        attribute :data
      end
    end
  end
end
