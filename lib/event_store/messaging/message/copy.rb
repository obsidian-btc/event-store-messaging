module EventStore
  module Messaging
    module Message
      module Copy
        extend self

        def self.call(source, receiver=nil, include: nil, exclude: nil)
          copy(source, receiver, include: include, exclude: exclude)
        end

        def copy(source, receiver=nil, include: nil, exclude: nil)
          if receiver.nil?
            receiver = self.class
          end

          if receiver.class == Class
            if receiver.method_defined? :build
              receiver = receiver.build
            else
              receiver = receiver.new
            end
          end

          SetAttributes.(receiver, source, include: include, exclude: exclude)
          receiver
        end
      end
    end
  end
end
