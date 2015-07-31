module EventStore
  module Messaging
    module StreamName
      extend self
      include EventStore::Client::StreamName

      def self.included(cls)
        cls.extend Macro
      end

      module Macro
        def category_macro(category_name)
          self.send :define_method, :category_name do
            category_name
          end
        end
        alias :category :category_macro

        def self.activate(target_class=nil)
          target_class ||= Object
          macro_module = self
          return if target_class.is_a? macro_module
          target_class.extend(macro_module)
        end
      end

      def stream_name(id)
        EventStore::Client::StreamName.stream_name category_name, id
      end

      def command_stream_name(id)
        EventStore::Client::StreamName.stream_name "#{category_name}:command", id
      end

      def category_stream_name(category_name=nil)
        category_name ||= self.category_name
        EventStore::Client::StreamName.category_stream_name(category_name)
      end

      def command_category_stream_name(category_name=nil)
        category_name ||= self.category_name
        category_stream_name = category_stream_name(category_name)

        "#{category_stream_name}:command"
      end

      def self.get_id(stream_name)
        EventStore::Client::StreamName.get_id stream_name
      end
    end
  end
end
