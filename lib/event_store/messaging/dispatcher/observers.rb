module EventStore
  module Messaging
    module Dispatcher
      class Observers
        dependency :logger, Telemetry::Logger

        def self.build
          instance = new
          Telemetry::Logger.configure instance
          instance
        end

        def dispatching(&observer)
          register :dispatching, &observer
        end

        def dispatched(&observer)
          register :dispatched, &observer
        end

        def failed(&observer)
          register :failed, &observer
        end

        def notify(event, notification)
          logger.trace "Notifying observers (Event: #{event.inspect}, Message Type: #{notification.message_type.inspect})"

          observer_count = 0

          registry.each_value do |registration|
            if registration.event == event
              registration.observer.(notification)
              observer_count += 1
            end
          end

          logger.debug "Notified observers (Event: #{event.inspect}, Message Type: #{notification.message_type.inspect}, Observers Notified: #{observer_count})"

          observer_count
        end

        def register(event, &observer)
          registration = Registration.new observer, event

          logger.trace "Registering observer (Event: #{event.inspect}, ID: #{registration.id.inspect})"

          registry[registration.id] = registration

          logger.debug "Registered observer (Event: #{event.inspect}, ID: #{registration.id.inspect})"

          registration.id
        end

        def registry
          @registry ||= {}
        end

        def unregister(id)
          registry.delete id
        end

        class Notification < Struct.new :message, :event_data
          def message_type
            message.message_type
          end

          class Failure < Notification
            attr_accessor :error
          end
        end

        module Assertions
          def notify?(observer, event)
            registration = registry[observer.object_id]

            registration && registration.event == event
          end

          def notify_dispatched?(observer)
            notify? observer, :dispatched
          end

          def notify_dispatching?(observer)
            notify? observer, :dispatching
          end

          def notify_failed?(observer)
            notify? observer, :failed
          end
        end

        Registration = Struct.new :observer, :event do
          def id
            observer.object_id
          end
        end

        module Substitute
          def self.build
            Observers.build
          end

          class Observers < Dispatcher::Observers
            def notify(event, notification)
              notifications[event] << notification
            end

            def notified?(event, message, event_data: nil, error: nil)
              notifications[event].any? do |notification|
                next unless notification.message == message

                next if event_data && notification.event_data != event_data
                next if error && notification.error != error

                true
              end
            end

            def notifications
              @notifications ||= Hash.new do |hash, event|
                hash[event] = []
              end
            end
          end
        end
      end
    end
  end
end
