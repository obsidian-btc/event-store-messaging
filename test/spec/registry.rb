require_relative 'spec_init'

describe "Registry" do
  it "Registers items" do
    registry = EventStore::Messaging::Registry.new

    item = Object.new

    registry.register item

    assert(registry.registered? item)
  end

  it "Registers items once only" do
    registry = EventStore::Messaging::Registry.new

    item = Object.new
    registry.register item

    assert_raises EventStore::Messaging::Registry::Error do
      registry.register item
    end
  end

  it "Optional, specialized work is done after registration" do
    registry = EventStore::Messaging::Registry.new

    thing = []

    registry.after_register do |item|

    end
  end
end
