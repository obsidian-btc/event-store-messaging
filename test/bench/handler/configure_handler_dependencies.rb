require_relative 'handler_init'

context "Configure a Handler's Dependencies" do
  test "Dependencies are configured in the course of building the handler" do
    handler = EventStore::Messaging::Controls::Handler::ConfiguredHandler.build
    assert(handler.configured_dependencies)
  end
end
