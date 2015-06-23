module EventStore
  module Messaging
    class CategoryWriter < Writer
      def self.build(*args)
        raise NotImplementedError
      end

      def self.configure(*args)
        raise NotImplementedError
      end

      def write(*args)
      end
    end
  end
end
