module EventStore
  module Messaging
    module Stream
      class Item
        attr_accessor :id
        attr_accessor :type
        attr_accessor :version
        attr_accessor :stream_name
        attr_accessor :data
      end
    end
  end
end
