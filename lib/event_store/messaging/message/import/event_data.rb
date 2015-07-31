module EventStore
  module Messaging
    module Message
      module Import
        module EventData
          class Error < RuntimeError; end

          def self.logger
            @logger ||= Telemetry::Logger.get self
          end

          def self.!(event_data, message_class)
          end
        end
      end
    end
  end
end

<<-reference
module Deserialize
  class Error < StandardError; end

  def deserialize(stream_entry)
    entry_type = stream_entry.type
    msg_class = message_registry.get(entry_type)

    msg = nil
    if msg_class
      msg_data = stream_entry.data
      raise Error, "No data in stream entry: #{stream_entry.inspect}" unless msg_data

      metadata = stream_entry.metadata

      msg = msg_class.build(msg_data, metadata)
    end

    return msg
  end
end
reference
