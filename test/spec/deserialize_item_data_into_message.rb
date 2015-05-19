require_relative 'spec_init'

describe "Deserialize Item Data" do
  specify "Message corresponding to the item type is built with the item's data" do
    item_data = Fixtures.stream_item_data
    msg, _ = Fixtures::SomeDispatcher.deserialize item_data
    assert(msg.is_a? Fixtures::SomeMessage)
  end
end

describe "Deserialize Item Data for an Unknown Message" do
  specify "Message is nil" do
    item_data = Fixtures::Anomalies.stream_item_data

    msg, _ = Fixtures::SomeDispatcher.deserialize item_data
    assert(msg.nil?)
  end
end
