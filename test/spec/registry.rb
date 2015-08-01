require_relative 'spec_init'

describe "Registry" do
  registry = EventStore::Messaging::Controls::Registry.example

  it "Registers items" do
    item = Object.new

    registry.register item

    assert(registry.registered? item)
  end

  it "Registers items once only" do
    item = Object.new
    registry.register item

    assert_raises EventStore::Messaging::Registry::Error do
      registry.register item
    end
  end

  it "Optional, specialized work is done after registration" do
    item = Object.new

    record = []

    registry.after_register do |item|
      record << item
    end

    registry.register item

    assert(record.include? item)
  end
end
