module Rubeus::Reflection
  module JavaMethods
    def self.activate
      ::Object.send(:include, ::Rubeus::Reflection::JavaMethods::Object)
      ::Module.send(:include, ::Rubeus::Reflection::JavaMethods::Module)
      ::Java::JavaClass.send(:include, ::Rubeus::Reflection::JavaMethods::JavaClass)
    end

    MODIFIERS = %w[public protected package_scope private final strict synchronized].freeze
    METATYPES = %w[class instance].freeze

    module JavaClass
      def method_missing(method_name, *args, &block)
        if method_name.to_s =~ /^java_(.+)_methods$/
          modifiers = $1.gsub(/_/, "-").gsub(/package-scope/, 'package_scope').split(/-/)
          metatype = METATYPES.include?(modifiers.last) ? modifiers.pop : "class"
          super unless (modifiers - MODIFIERS).empty?
          result = self.send("declared_#{metatype}_methods")
          result = (metatype == 'class') ? result.select(&:static?) : result.select{|m| !m.static?}
          modifiers.each do |modifier|
            predication = "#{modifier}?".to_sym
            result = result.select(&predication)
          end
          result
        else
          super
        end
      end

    end

    module Object
      def java_methods
        self.is_a?(Module) ? self.java_class_methods : self.class.java_instance_methods
      end
    end

    module Module
      def java_instance_methods
        to_java_methods(:java_instance_methods)
      end

      def java_public_isntance_methods
        to_java_methods(:java_public_instance_methods)
      end

      def java_class_methods
        to_java_methods(:java_class_methods)
      end
      alias_method :java_singleton_methods, :java_class_methods

      def java_public_class_methods
        to_java_methods(:public_class_methods)
      end

      private
      def to_java_methods(method_name, &block)
        return nil unless respond_to?(:java_class)
        result = java_class.send(method_name)
        result.map(&:name).uniq
      end
    end

  end
end

