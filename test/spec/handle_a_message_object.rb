require_relative 'spec_init'

describe "Handler" do
  it "Handles" do
    handler = Fixtures.handler
    message = Fixtures.message

    handler.handle message

    assert(message.handler? "SomeHandler")
  end
end
