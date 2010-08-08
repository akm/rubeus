module Rubeus::Extensions::Javax::Swing
  module JSplitPane
    def self.included(base)
      base.perform_as_container
      base.extend(ClassMethods)
      base.instance_eval do
        alias :new_without_rubeus :new
        alias :new :new_with_rubeus
      end
    end

    module ClassMethods
      def new_with_rubeus(new_orientation, *args, &block)
        if new_orientation.is_a?(Symbol)
          new_orientation = const_get(new_orientation)
        end
        new_without_rubeus(new_orientation, *args, &block)
      end

      def add_new_component_to(object, &block)
        Rubeus::Awt::Nestable::Context.add_new_component_to(object, :append_component, &block)
      end
    end

    def append_component(component)
      append_method =
        (self.orientation == javax.swing.JSplitPane::VERTICAL_SPLIT) ?
          (top_component ? :set_bottom_component : :set_top_component) :
          (left_component ? :set_right_component : :set_left_component)
      send(append_method, component)
    end
  end
end
