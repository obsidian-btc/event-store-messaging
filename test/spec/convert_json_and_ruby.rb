require_relative 'spec_init'

describe "Data hash with JSON names" do
  specify "Is converted to a hash with Ruby names" do

  end
end

=begin
- where is this done?
- at which object/level
- subscription probably

- client::serializer converts to JSON
- client::deserializer convers to Ruby

- anything that reads converts to Ruby (underscore_case)
- anything that writes converts to JSON
=end

module Format
  module JSON
    def format(data)
      Casing::Hash::Camel.! data
    end
  end

  module Ruby
    def format(data)
      Casing::Hash::Underscore.! data
    end
  end
end
