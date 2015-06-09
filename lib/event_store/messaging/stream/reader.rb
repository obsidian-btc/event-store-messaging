module EventStore
  module Messaging
    module Stream
      class Reader
        class Error < StandardError; end

        dependency :subscription, ::EventStore::Client::HTTP::Vertx::Subscription
        dependency :dispatcher, EventStore::Messaging::Dispatcher
        dependency :logger, Telemetry::Logger

        # TODO Needs dispatcher [Scott, Thu Jun 4 2015]
        def self.build(subscription)
          new.tap do |instance|
            instance.subscription = subscription
          end
        end

        def self.start
          instance = build
          instance.start
        end

        def start
          subscription.start &action
        end

        def action
          this = self
          Proc.new do |stream_entry|
            this.read stream_entry
          end
        end

        def read(stream_entry)
          message, stream_entry = dispatcher.deserialize(stream_entry)

          if message
            dispatcher.dispatch(message, stream_entry)
          else
            logger.debug "Cannot dispatch \"#{stream_entry.type}\". The \"#{dispatcher}\" dispatcher has no handlers for it."
          end

          return message, stream_entry
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
