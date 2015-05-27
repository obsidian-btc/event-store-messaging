module EventStore
  module Messaging
    module Stream
      class Reader
        class Error < StandardError; end

        dependency :subscription, EventStore::Client::HTTP::Subscription
        dependency :dispatcher, EventStore::Messaging::Dispatcher
        dependency :logger, Telemetry::Logger

        def self.build
          new().tap do |instance|
            EventStore::Client::HTTP::Subscription.configure instance
            # here is where http client is added to subs?
          end
        end

        def self.start
          instance = build
          instance.start
        end

        def configure_subscription_action
          this = self
          subscription.action = Proc.new do |data|
            this.read data
          end
        end

        def start
          configure_subscription_action
          subscription.start
        end

        def read(data)
          message, stream_item = dispatcher.deserialize(data)

          if message
            dispatcher.dispatch(message, stream_item)
          else
            logger.debug "Cannot dispatch \"#{stream_item.type}\". The \"#{dispatcher}\" dispatcher has no handlers for it."
          end

          return message, stream_item
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
