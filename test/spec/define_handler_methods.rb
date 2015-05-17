require_relative 'spec_init'

describe "Handler Macro" do
  it "Defines handler methods" do
    handler = Fixtures.handler
    assert(handler.respond_to? :handle_some_message)
  end

  it "Registers message classes" do
    handler = Fixtures.handler
    handler.class.message_registry.registered? Fixtures::SomeMessage
  end
end
