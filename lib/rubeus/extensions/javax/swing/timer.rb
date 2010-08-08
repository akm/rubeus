module Rubeus::Extensions::Javax::Swing
  module Timer
    def self.included(base)
      base.extend ClassMethods
      base.instance_eval do
        alias :new_without_rubeus :new
        alias :new :new_with_rubeus
      end
    end

    module ClassMethods
      def new_with_rubeus(interval, &block)
        # Create ActionListener implement class
        mod = Module.new do
          define_method("actionPerformed", &block)
        end

        obj = Object.new
        obj.extend(mod)

        # Use original constructor
        new_without_rubeus(interval, obj)
      end
    end
  end
end
