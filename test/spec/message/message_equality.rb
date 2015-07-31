require_relative 'message_init'

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

  specify "When message classes aren't equal" do
    other_message = Fixtures.some_other_message
    other_message.some_attribute = 'some value'
    assert(message == other_message)
  end

  specify "When data isn't equal" do
    other_message = Fixtures.some_message
    other_message.some_attribute = 'some other value'
    refute(message == other_message)
  end
end
