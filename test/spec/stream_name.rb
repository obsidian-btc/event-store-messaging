require_relative 'spec_init'

module Fixtures
  module StreamName
    class Example
      include EventStore::Messaging::StreamName

      category 'someCategory'
    end

    def self.example
      Example.new
    end
  end
end

describe "Stream Name" do
  example = Fixtures::StreamName.example

  specify "Category macro adds the category_name method" do
    assert(example.category_name == 'someCategory')
  end

  specify "Composes the stream name from the category name and an ID" do
    stream_name = example.stream_name('some_id')
    assert(stream_name == 'someCategory-some_id')
  end
end

describe "Stream ID" do
  id = UUID.random
  stream_name = "someStream-#{id}"

  specify "Can be derived from the stream name" do
    stream_id = EventStore::Messaging::StreamName.get_id stream_name
    assert(stream_id == id)
  end
end
