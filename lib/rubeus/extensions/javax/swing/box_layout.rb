module Rubeus::Extensions::Javax::Swing
  module BoxLayout
    def self.included(base)
      base.extend(ClassMethods)
      base.instance_eval do
        alias :new_without_nestable :new
        alias :new :new_with_nestable
      end
    end

    module ClassMethods
      def new_with_nestable(*args, &block)
        if args.length == 1
          container = Rubeus::Awt::Nestable::Context.container
          raise ArgumentError, "No container! you must specify a Container and an axis" unless container
          args.unshift(container.respond_to?(:content_pane) ? container.content_pane : container)
        end

        unless args.last.is_a?(Integer)
          value = args.pop
          args << const_get(value.to_s)
        end

        new_without_nestable(*args, &block)
      end
    end
  end
end
