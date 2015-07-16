# Event Store Messaging library

## Creating a Message Class

A message class should sit within a Messages namespace and include the EventStore::Messaging::Message module. Any data that a message includes is written as an attribute in the class:

```ruby
module Messages
  class SomeMessage
    include EventStore::Messaging::Message

    attribute :some_attribute
    attribute :some_other_attribute
  end
end
```

Attributes provide getter/setter methods for the message class:

```ruby
message = Messages::SomeMessage.new

message.some_attribute = 'some_value'

message.some_attribute == 'some_value'
# => true
```

Messages can also be converted into hashes:

```ruby
message = Messages::SomeMessage.new

message.some_other_attribute = 'some_other_value'

message.to_h[:some_other_attribute] == 'some_other_value'
# => true
```

### Message Info



### Message Metadata

In addition to structure and messaging capabilities, this also provides each message class with a `metadata` attribute. **The `metadata` attribute is not something that should be edited directly. Rather, it is created automically when the message is built.**

EventStore::Messaging::Message::Metadata is a class with specified attributes. The following attributes are assigned when a message is built, based on the information provided:

- correlation_stream_name (the stream name of the correlating process coordinating this succession of messages)
- causation_event_id (the id of the specific event/message that initiated the creation of the current message, if there was a causation event)
- causation_stream_name (the stream name to which the causation event was written, if there was a causation event)

The remaining attributes are assigned when the message is written:

- event_id (the id of the event/message in EventStore)
- source_stream_name (the stream name to which the event/message is written)
- reply_stream_name (the stream name to which a command should reply when the command has been executed, if needed)
- version
