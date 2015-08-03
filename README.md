# EventStore Messaging

## Message

```ruby
class SomeMessage
  include EventStore::Messaging::Message

  attribute :some_attribute
  attribute :some_time
end
```

## Handler

```ruby
class SomeHandler
  include EventStore::Messaging::Handler

  handle SomeMessage do |message, event_data|
    logger.data message.inspect
    logger.data event_data.inspect
  end
end
```

## Dispatcher

```ruby
class SomeDispatcher
  include EventStore::Messaging::Dispatcher

  handler SomeHandler
  handler SomeOtherHandler # Note: Omitted for brevity of this example
end
```

## Subscription

```ruby
dispatcher = SomeDispatcher.new

reader = EventStore::Messaging::Reader.build stream_name, dispatcher

reader.subscribe
```
