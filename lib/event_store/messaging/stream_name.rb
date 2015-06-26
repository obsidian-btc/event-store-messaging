module EventStore
  module Messaging
    module StreamName
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

      def self.get_id(stream_name)
        stream_name.match(/[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/i).to_s
      end
    end
  end
end
