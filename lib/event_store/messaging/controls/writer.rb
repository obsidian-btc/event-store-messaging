module EventStore
  module Messaging
    module Controls
      module Writer
        def self.write(count=nil, stream_name=nil)
          count ||= 1

          stream_name = Controls::StreamName.get stream_name
          path = "/streams/#{stream_name}"

          writer = EventStore::Messaging::Writer.build

          count.times do |i|
            time = Clock::UTC.iso8601
            message = Controls::Message.example(time)

            writer.write message, stream_name
          end

          stream_name
        end

        module Telemetry
          module Sink
            class Example
              include ::Telemetry::Sink

              record :written
              record :replied
            end

            def self.example
              Example.new
            end
          end
        end
      end
    end
  end
end
