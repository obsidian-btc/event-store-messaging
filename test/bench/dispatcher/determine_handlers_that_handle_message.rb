require_relative 'dispatcher_init'

context "Dispatcher" do
  test "Determines handlers that it can dispatch a message to" do
    dispatcher = EventStore::Messaging::Controls::Dispatcher.example
    message = EventStore::Messaging::Controls::Message.example

    handler_classes = dispatcher.handlers.get(message)

    names = handler_classes.map do |handler_class|
      handler_class.name.split('::').last
    end

    assert(names.include? 'SomeHandler')
    assert(names.include? 'OtherHandler')
    assert(!(names.include? 'AnotherHandler'))
  end
end
