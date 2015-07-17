# Event Store Messaging library

## Creating a Message Class

A message class should sit within a Messages namespace and include the EventStore::Messaging::Message module. Any message data is defined as an attribute in the class:

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

Given a message, you can determine the message type and/or the message name:

```ruby
message = Messages::SomeMessage.new

message.message_type
# => SomeMessage

message.message_name
# => some_message
```

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


## Building a Message Object

A message object serves two main purposes:

1. Provided a data schema for passing data
2. Tracking metadata

### Using the `build` Method

If the message is purely being used for the provided data schema and will not be sent on, the message can be built using the basic build method:

```ruby
data = {
  some_attribute: 'some value',
  some_other_attribute: 'some other value',
  some_other_data: 'some other data'
}

message = Messages::SomeMessage.build(data: data)
```

One potential use case for this is filtering out extraneous data from an incoming http request. The `metadata` values are not set using this method.


### Using the `initial` Method

The first message object for a process is built by using the `initial` method and passing in the correlation stream name for the overarching process.

```ruby
some_process_id = uuid.get
correlation_stream_name = 'someProcess-#{some_process_id}'

message = Messages::SomeMessage.initial correlation_stream_name
```

In this case, the correlation_stream_name would be set to the process stream name that is being passed in. The causation_event_id and causation_stream_name would not be set, as it is the first message in this process.
