require_relative 'spec_init'

describe "Deserialize Entry Data" do
  specify "Message corresponding to the entry type is built with the entry's data" do
    entry_data = Fixtures.stream_entry_data
    msg, _ = Fixtures::SomeDispatcher.deserialize entry_data
    assert(msg.is_a? Fixtures::SomeMessage)
  end
end

describe "Deserialize Entry Data for an Unknown Message" do
  specify "Message is nil" do
    entry_data = Fixtures::Anomalies.stream_entry_data

    msg, _ = Fixtures::SomeDispatcher.deserialize entry_data
    assert(msg.nil?)
  end
end
