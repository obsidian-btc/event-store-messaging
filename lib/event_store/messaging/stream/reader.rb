module EventStore
  module Messaging
    module Stream
      class Reader
        class Error < StandardError; end

        dependency :subscription, ::EventStore::Client::HTTP::Vertx::Subscription
        dependency :dispatcher, EventStore::Messaging::Dispatcher
        dependency :logger, Telemetry::Logger

        def self.build
          new.tap do |instance|
            Telemetry::Logger.configure instance
          end
        end

        def self.start
          instance = build
          instance.start
        end

        def start(&supplemental_action)
          logger.trace "Starting"

          action = self.action(&supplemental_action)

          subscription.start &action

          logger.debug "Start completed"
        end

        def action(&supplemental_action)
          logger.trace "Composing action"
          Proc.new do |stream_entry|
            read stream_entry
            supplemental_action.call(stream_entry) if supplemental_action
          end.tap do
            logger.debug "Composed action"
          end
        end

        def read(stream_entry)
          logger.trace "Reading stream entry (Type: #{stream_entry.type}, ID: #{stream_entry.id}"

          message = dispatcher.deserialize(stream_entry)

          if message
            dispatcher.dispatch(message, stream_entry)
          else
            logger.debug "Cannot dispatch \"#{stream_entry.type}\". The \"#{dispatcher}\" dispatcher has no handlers for it."
          end

          logger.debug "Read stream entry (Type: #{stream_entry.type}, ID: #{stream_entry.id}"

          return message
        end

        pure_virtual :stream_name

        module Substitute
          def self.build
            Reader.new.extend Instruments
          end

          module Instruments
            def self.extended(obj)
              Telemetry::Logger.get(self).debug "Instrumented #{obj.class.name}"
            end

            def reads
              @reads ||= []
            end

            def read(data)
              reads << data
            end

            def read?(data)
              reads.include? data
            end
          end
        end
      end
    end
  end
end
