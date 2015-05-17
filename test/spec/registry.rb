require_relative 'spec_init'

describe "Registry" do
  it "Registers items" do
    registry = Object.extend EventStore::Messaging::Registry

    item = Object.new

    registry.register item

    assert(registry.registered? item)
  end

  it "Registers message classes once only" do
    registry = Object.extend EventStore::Messaging::Registry

    item = Object.new
    registry.register item

    assert_raises EventStore::Messaging::Registry::Error do
      registry.register item
    end
  end
end
