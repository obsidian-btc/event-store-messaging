module EventStore
  module Messaging
    module Stream
      class Writer
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

          def entries
            @entries ||= []
          end

          def write(msg)
            entry = EventStore::Messaging::Message::StreamEntry.! msg
            entries << entry
            entry
          end

          def written?(entry)
            entries.include? entry
          end
        end
      end
    end
  end
end
