module EventStore
  module Messaging
    module StreamName
      extend self
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
        "#{category_name}-#{id}"
      end

      def command_stream_name(id)
        "#{category_name}:command-#{id}"
      end

      def category_stream_name(category_name=nil)
        category_name ||= self.category_name
        "$ce-#{category_name}"
      end

      def command_category_stream_name(category_name=nil)
        category_name ||= self.category_name
        "$ce-#{category_name}:command"
      end

      def self.get_id(stream_name)
        id = stream_name.match(/[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/i).to_s
        id = nil if id == ''
        id
      end
    end
  end
end
