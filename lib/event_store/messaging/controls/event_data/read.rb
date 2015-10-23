module EventStore
  module Messaging
    module Controls
      module EventData
        module Read
          def self.data(number=nil, time: nil, stream_name: nil, metadata: nil, type: nil, omit_metadata: nil)
            reference_time = ::Controls::Time.reference

            number ||= 0
            time ||= reference_time
            stream_name ||= StreamName.reference

            omit_metadata ||= false

            unless omit_metadata
              metadata ||= EventStore::Messaging::Controls::Message::Metadata.data
            else
              metadata = nil
            end

            type ||= 'SomeMessage'

            data = {
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

            if metadata.nil?
              data.delete 'metadata'
            end

            data
          end

          def self.example(omit_metadata: nil)
            data = data(omit_metadata: omit_metadata)
            data['links'] = EventStore::Client::HTTP::EventData::Read::Links.build data['links']

            EventStore::Client::HTTP::EventData::Read.build data
          end

          module Anomaly
            def self.data
              Read.data type: 'SomeUnknownMessage'
            end

            def self.example
              EventStore::Client::HTTP::EventData::Read.build data
            end
          end
        end
      end
    end
  end
end
