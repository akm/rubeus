module Rubeus::Reflection
  module JavaMethods
    def self.activate
      ::Java::JavaClass.send(:include, ::Rubeus::Reflection::JavaMethods::JavaClass)
      ::Object.send(:include, ::Rubeus::Reflection::JavaMethods::Object)
    end

    MODIFIERS = %w[public protected package_scope private final strict synchronized].freeze
    METATYPES = %w[instance class singleton].freeze

    JAVA_METHODS_PATTERN = /^java_(.+)_methods$/.freeze

    def self.parse(method_name)
      if method_name.to_s == 'java_methods'
        return [], nil
      elsif method_name.to_s =~ JAVA_METHODS_PATTERN
        modifiers = $1.gsub(/_/, "-").gsub(/package-scope/, 'package_scope').split(/-/)
        metatype = METATYPES.include?(modifiers.last) ? modifiers.pop : nil
        if metatype == 'singleton'
          metatype = 'class'
        end
        if (modifiers - MODIFIERS).empty?
          return modifiers, metatype
        else
          return nil, nil
        end
      else
        return nil, nil
      end
    end

    module JavaClass
      def method_missing(method_name, *args, &block)
        modifiers, metatype = JavaMethods.parse(method_name)
        if modifiers
          metatype ||= 'class'
          result = self.send("declared_#{metatype}_methods")
          result = result.send((metatype == 'class') ? :select : :reject, &:static?)
          modifiers.each do |modifier|
            predication = "#{modifier}?".to_sym
            result = result.select(&predication)
          end
          result
        else
          super
        end
      end

      def respond_to?(method_name)
        modifiers, metatype = JavaMethods.parse(method_name)
        !!modifiers || super
      end
    end

    module Object
      def method_missing(method_name, *args, &block)
        modifiers, metatype = JavaMethods.parse(method_name)
        return super unless modifiers
        if is_a?(Module)
          case metatype
          when nil then to_java_methods(method_name)
          when 'class' then to_java_methods(method_name)
          when 'instance' then to_java_methods(method_name) # self.send(method_name, *args, &block)
          else
            raise "something wrong..."
          end
        else
          case metatype
          when nil then self.class.send(method_name.to_s.gsub(/_methods$/, '_instance_methods'), *args, &block)
          when 'class' then raise NoMethodError
          when 'instance' then self.class.send(method_name, *args, &block)
          else
            raise "something wrong..."
          end
        end
      end

      def respond_to?(method_name)
        modifiers, metatype = JavaMethods.parse(method_name)
        return super unless modifiers
        return true if is_a?(Module)
        metatype != 'class'
      end

      private
      def to_java_methods(method_name)
        return nil unless respond_to?(:java_class)
        result = java_class.send(method_name)
        result.map(&:name).uniq
      end
    end

  end
end

