module Rubeus::Awt
  module Nestable
    def self.included(klass)
      klass.extend(ClassMethods)
      klass.instance_eval do
        alias :new_without_nestable :new
        alias :new :new_with_nestable
      end
    end

    class Context
      def self.container_class_names
        @container_class_names ||= []
      end

      def self.container_class_names=(*class_names)
        @container_class_names = class_names
      end

      def self.register_as_container(*class_names)
        self.container_class_names.concat(class_names)
      end

      def self.add_component_if_container_exist(component, &block)
        @container ||= nil
        @container.send(@action, component) if @container
      end

      def self.add_new_component_to(container, action = :add, block_argument = nil, &block)
        former_container = @container
        former_action = @action
        @container = container
        @action = action
        begin
          yield(block_argument || container)
        ensure
          @container = former_container
          @action = former_action
        end
      end

      def self.container
        @container
      end
    end


    module ClassMethods
      def new_with_nestable(*args, &block)
        object = self.new_without_nestable(*args)
        Context.add_component_if_container_exist(object)
        return object unless block_given?
        process_block_for_new(object, &block)
        return object
      end

      def container?
        Context.container_class_names.include?(self.java_class.name)
      end

      def perform_as_container
        Context.container_class_names << self.java_class.name
      end

      def perform_as_containee
        Context.container_class_names.delete(self.java_class.name)
      end

      def process_block_for_new(object, &block)
        if self.container?
          self.add_new_component_to(object, &block)
        elsif object.respond_to?(:listen)
          object.listen(*self.default_event_type, &block)
        else
          raise "#{self.java_class.name} doesn't support process_block_for_new"
        end
      end

      def add_new_component_to(object, &block)
        Context.add_new_component_to(object, &block)
      end

      def default_event_type
        :action
      end
    end
  end
end
