require_relative 'handler_init'

describe "Configure a Handler's Dependencies" do
  specify "Dependencies are configured in the course of building the handler" do
    handler = EventStore::Messaging::Controls::Handler::ConfiguredHandler.build
    assert(handler.configured_dependencies)
  end
end