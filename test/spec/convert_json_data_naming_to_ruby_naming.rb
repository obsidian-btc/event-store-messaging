require 'pp'
require_relative 'spec_init'

module SymbolHashKeys
  def self.!(hash)
    convert_keys hash
  end

  def self.convert_keys(val)
    case val
      when ::Array
        val.map { |v| convert_keys(v) }
      when ::Hash
        ::Hash[val.map { |k, v| [convert_key(k), convert_keys(v)] }]
      else
        val
    end
  end

  def self.convert_key(key)
    key = key.to_sym if key.respond_to? :to_sym
    key
  end
end

describe "Item data with JSON names" do
  specify "Is converted to data Ruby names" do
    item_json_data = Fixtures.stream_item_json_data
    _, stream_item = Fixtures::SomeDispatcher.deserialize item_json_data

    stream_item_data = stream_item.to_h
    stream_item_data = SymbolHashKeys.!(stream_item_data)

    control_data = Fixtures.stream_item_data

    assert(stream_item_data == control_data)
  end
end
