require 'rubeus/util'

module Rubeus
  module Util
    module JavaMethodName
      def self.enable
        Object.module_eval do
          def java_methods
            self.class.java_methods
          end
        end
        Module.send(:include, self)
      end

      def java_method_objects
        return [] unless respond_to?(:java_class) && java_class
        java_class.java_instance_methods
      end

#       def private_java_method_objects
#         java_method_objects.select()
#       end

#       def java_methods
#         java_method_objects.map(&:name)
#       end

    end
  end
end

