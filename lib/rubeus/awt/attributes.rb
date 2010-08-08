module Rubeus::Awt
  module Attributes
    def self.included(base)
      base.extend(ClassMethods)
      base.instance_eval do
        alias :new_without_attributes :new
        alias :new :new_with_attributes
      end
    end

    module ClassMethods
      def new_with_attributes(*args, &block)
        options = args.last.is_a?(Hash) ? args.pop : {}
        result = self.new_without_attributes(*args, &block)
        attributes = ((@class_to_default_attributes || {})[self.java_class.name] || {}).merge(options)
        if respond_to?(:update_attributes)
          update_attributes(result, attributes)
        else
          attributes.each do |attr, value|
            begin
              value = (self.const_get(value) rescue value) if value.is_a?(Symbol)
              result.send("#{attr.to_s}=", value)
            rescue
              raise ArgumentError, "Failed setting #{value.inspect} to #{attr.inspect} cause of #{$!.to_s}"
            end
          end
        end
        result
      end

      def default_attributes(attributes = nil)
        self.default_attributes = attributes if attributes
        result = {}
        @class_to_default_attributes ||= {}
        classes = self.ancestors.select{|klass|
          !klass.java_class.interface? and klass.respond_to?(:default_attributes)}
        classes.reverse.each do |klass|
          if attrs = @class_to_default_attributes[klass.java_class.name]
            result.update(attrs)
          end
        end
        result
      end

      def default_attributes=(attributes)
        @class_to_default_attributes ||= {}
        @class_to_default_attributes[self.java_class.name] ||= (attributes || {})
      end

    end
  end
end
