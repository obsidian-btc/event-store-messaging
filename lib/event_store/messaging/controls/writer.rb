module EventStore
  module Messaging
    module Controls
      module Writer
        def self.write(count=nil, stream_name=nil, stream_metadata: nil)
          count ||= 1

          stream_name ||= Controls::StreamName.get stream_name
          path = "/streams/#{stream_name}"

          writer = EventStore::Messaging::Writer.build

          count.times do |i|
            time = Clock::UTC.iso8601
            message = Controls::Message.example(time)

            writer.write message, stream_name
          end

          if stream_metadata
            EventStore::Client::HTTP::StreamMetadata::Update.(stream_name) do |metadata|
              metadata.update stream_metadata
            end
          end

          stream_name
        end
      end
    end
  end
end
