module EventStore
  module Messaging
    module Controls
      module Message
        module Metadata
          def self.foo
            raise 'in foo'
          end

          def self.uuid
            ::Controls::ID.get
          end

          def self.correlation_stream_name
            "correlationStream-#{uuid}"
          end

          def self.causation_event_uri
            "streams/causationStream-#{uuid}/0"
          end

          def self.reply_stream_name
            "replyStream-#{uuid}"
          end

          def self.schema_version
            11
          end

          def self.data
            {
              correlation_stream_name: Metadata.correlation_stream_name,
              causation_event_uri: Metadata.causation_event_uri,
              reply_stream_name: Metadata.reply_stream_name,
              schema_version: Metadata.schema_version
            }
          end

          def self.example
            EventStore::Messaging::Message::Metadata.build data
          end

          module JSON
            def self.data
              {
                correlationStreamName: Metadata.correlation_stream_name,
                causationEventUri: Metadata.causation_event_uri,
                replyStreamName: Metadata.reply_stream_name,
                schemaVersion: Metadata.schema_version
              }
            end
          end
        end
      end
    end
  end
end
