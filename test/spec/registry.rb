require_relative 'spec_init'

context "Registry" do
  registry = EventStore::Messaging::Controls::Registry.example

  test "Registers items" do
    item = Object.new

    registry.register item

    assert(registry.registered? item)
  end

  test "Registers items once only" do
    item = Object.new
    registry.register item

    begin
      registry.register item
    rescue EventStore::Messaging::Registry::Error => error
    end

    assert error
  end

  test "Optional, specialized work is done after registration" do
    item = Object.new

    record = []

    registry.after_register do |item|
      record << item
    end

    registry.register item

    assert(record.include? item)
  end
end
