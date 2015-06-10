module EventStore
  module Messaging
    class Writer
      # TODO Dependency on client writer (writes stream entry)
      # dependency :entry_writer

      pure_virtual :write

      # def self.stream_name_macro(stream_name)
      def self.stream_name(stream_name)
        # define stream name instance method with return value
      end
      # alias :stream_name :stream_name_macro
      # NOTE: will alias work like this given inheritance?

      class Substitute
        def self.build
          new
        end

        def messages
          @messages ||= []
        end

        def write(msg)
          messages << msg
          msg
        end

        def written?(msg)
          messages.include? msg
        end
      end
    end
  end
end
