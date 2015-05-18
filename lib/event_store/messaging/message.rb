module EventStore
  module Messaging
    module Message
      def self.included(cls)
        cls.send :include, DataStructure
      end
    end
  end
end
