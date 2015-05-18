require_relative 'spec_init'

describe "Dispatcher" do
  it "Determines handlers that it can dispatch a message to" do
    dispatcher = Fixtures.dispatcher
    message = Fixtures.message

    handler_classes = dispatcher.message_handlers(message)

    names = handler_classes.map do |handler_class|
      handler_class.name.split('::').last
    end

    assert(names.include? 'SomeHandler')
    assert(names.include? 'OtherHandler')
    refute(names.include? 'AnotherHandler')
  end
end
