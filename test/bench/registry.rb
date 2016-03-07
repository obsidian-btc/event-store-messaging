require_relative 'bench_init'

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

    assert proc { registry.register item } do
      raises_error? EventStore::Messaging::Registry::Error
    end
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
