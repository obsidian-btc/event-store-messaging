require_relative 'spec_init'

describe "Deserialize Item Data" do
  specify "Message corresponding to the item type is built with the item's data" do
    item_data = Fixtures.item_data
    msg = Fixtures::SomeDispatcher.deserialize item_data
    assert(msg.is_a? Fixtures::SomeMessage)
  end
end

describe "Deserialize Item Data for an Unknown Message" do
  specify "Is an error" do
    item_data = Fixtures::Anomalies.item_data

    assert_raises EventStore::Messaging::Dispatcher::Deserialize::Error do
      Fixtures::SomeDispatcher.deserialize item_data
    end
  end
end
