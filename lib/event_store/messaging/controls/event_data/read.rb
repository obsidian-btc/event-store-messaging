module EventStore
  module Messaging
    module Controls
      module EventData
        module Read
          def self.raw_data(number=nil, time: nil, stream_name: nil, metadata: nil, type: nil, omit_metadata: nil)
            type ||= 'SomeMessage'

            EventStore::Client::HTTP::Controls::EventData::Read.raw_data(
              number,
              time: time,
              stream_name: stream_name,
              metadata: metadata,
              type: type,
              omit_metadata: omit_metadata
            )
          end

          def self.example(omit_metadata: nil)
            raw_data = raw_data(omit_metadata: omit_metadata)

            Serialize::Read.instance raw_data, Client::HTTP::EventData::Read
          end

          module Anomaly
            def self.raw_data
              Read.raw_data type: 'SomeUnknownMessage'
            end

            def self.example
              Serialize::Read.instance raw_data, Client::HTTP::EventData::Read
            end
          end
        end
      end
    end
  end
end
