# module EventStore
#   module Messaging
#     module Controls
#       module EventData
#         module Read
#           def self.data(number=nil, time: nil, stream_name: nil, metadata: nil)
#             reference_time = ::Controls::Time.reference

#             number ||= 0
#             time ||= reference_time
#             stream_name ||= StreamName.reference

#             metadata ||= EventStore::Messaging::Controls::EventData::Metadata.data

#             links = nil

#             {
#               'type' => 'SomeEvent',
#               'number' => number,
#               'stream_name' => stream_name,
#               'created_time' => reference_time,
#               'data' => {
#                 'someAttribute' => 'some value',
#                 'someTime' => time
#               },
#               'metadata' => metadata,
#               'links' => [
#                 {
#                   'uri' => "http://localhost:2113/streams/#{stream_name}/#{number}",
#                   'relation' => 'edit'
#                 }
#               ]
#             }
#           end

#           def self.example
#             data = data()

#             metadata ||= EventStore::Messaging::Controls::EventData::Metadata.example

#             data['metadata'] = Metadata.example
#             EventStore::Client::HTTP::EventData::Read.build data
#           end
#         end
#       end
#     end
#   end
# end
