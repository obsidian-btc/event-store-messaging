require_relative 'spec_init'

describe "Message Equality" do
  message = Fixtures.some_message
  message.some_attribute = 'some value'

  other_message = Fixtures.some_message
  other_message.some_attribute = 'some value'

  specify "When data is equal" do
    assert(message == other_message)
  end
end

describe "Message Inequality" do
  message = Fixtures.some_message
  message.some_attribute = 'some value'

  other_message = Fixtures.some_message
  other_message.some_attribute = 'some other value'

  specify "When data is equal" do
    refute(message == other_message)
  end
end
