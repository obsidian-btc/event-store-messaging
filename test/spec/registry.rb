require_relative 'spec_init'

describe "Registry" do
  it "Registers items" do
    registry = Fixtures.registry

    item = Object.new

    registry.register item

    assert(registry.registered? item)
  end

  it "Registers items once only" do
    registry = Fixtures.registry

    item = Object.new
    registry.register item

    assert_raises EventStore::Messaging::Registry::Error do
      registry.register item
    end
  end

  it "Optional, specialized work is done after registration" do
    registry = Fixtures.registry

    item = Object.new

    record = []

    registry.after_register do |item|
      record << item
    end

    registry.register item

    assert(record.include? item)
  end
end
