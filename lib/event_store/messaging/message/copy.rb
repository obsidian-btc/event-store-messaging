module EventStore
  module Messaging
    module Message
      module Copy
        class Error < RuntimeError; end

        extend self

        def self.call(source, receiver=nil, include: nil, exclude: nil, strict: nil)
          copy(source, receiver, include: include, exclude: exclude, strict: strict)
        end

        def copy(source, receiver=nil, include: nil, exclude: nil, strict: nil)
          if receiver.nil?
            receiver = self
          end

          if receiver.class == Class
            if receiver.method_defined? :build
              receiver = receiver.build
            else
              receiver = receiver.new
            end
          end

          strict = true if strict.nil?

          begin
            SetAttributes.(receiver, source, include: include, exclude: exclude, strict: strict)
          rescue SetAttributes::Attribute::Error => e
            raise Error, e.message, e.backtrace
          end

          receiver
        end
      end
    end
  end
end
