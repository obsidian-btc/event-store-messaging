require_relative 'spec_init'

describe "Handler" do
  it "Registers classes of messages that it handles" do
    handler = Fixtures.handler

    message_registry = handler.class.message_registry

    assert(message_registry.registered? Fixtures::SomeMessage)
  end
end
