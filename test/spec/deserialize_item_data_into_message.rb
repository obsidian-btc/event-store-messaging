require_relative 'spec_init'

describe "Deserialize Entry Data" do
  specify "Message corresponding to the entry type is built with the entry's data" do
    stream_entry = Fixtures.stream_entry
    msg, _ = Fixtures::SomeDispatcher.deserialize stream_entry
    assert(msg.is_a? Fixtures::SomeMessage)
  end
end

describe "Deserialize Entry Data for an Unknown Message" do
  specify "Message is nil" do
    stream_entry = Fixtures::Anomalies.stream_entry

    msg, _ = Fixtures::SomeDispatcher.deserialize stream_entry
    assert(msg.nil?)
  end
end
