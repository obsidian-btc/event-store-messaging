module EventStore
  module Messaging
    module Controls
      module EventData
        module Read
          def self.data(number=nil, time: nil, stream_name: nil, metadata: nil, type: type)
            reference_time = ::Controls::Time.reference

            number ||= 0
            time ||= reference_time
            stream_name ||= StreamName.reference
            metadata ||= EventStore::Messaging::Controls::Message::Metadata.data
            type ||= 'SomeMessage'

            {
              'type' => type,
              'number' => number,
              'stream_name' => stream_name,
              'created_time' => reference_time,
              'data' => Controls::Message.data,
              'metadata' => metadata,
              'links' => [
                {
                  'uri' => "http://localhost:2113/streams/#{stream_name}/#{number}",
                  'relation' => 'edit'
                }
              ]
            }
          end

          def self.example
            data = data()
            data['links'] = EventStore::Client::HTTP::EventData::Read::Links.build data['links']

            EventStore::Client::HTTP::EventData::Read.build data
          end
        end
      end
    end
  end
end
