require_relative 'spec_init'

describe "Handler" do
  it "Determine whether it handles based on a message class name" do
    handler = Fixtures.handler
    message_name = "SomeMessage"

    assert(handler.class.handles? message_name)
  end

  it "Determine whether it handles based on a message object" do
    handler = Fixtures.handler
    message = Fixtures.message

    assert(handler.class.handles? message)
  end

  it "Determine whether it handles based on a message class" do
    handler = Fixtures.handler
    message = Fixtures.message

    assert(handler.class.handles? message.class)
  end
end
