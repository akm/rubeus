module Rubeus::Awt
  module Event
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def uncapitalize(str)
        str[0..0].downcase + str[1..-1]
      end
    end

    def find_java_method(method_name, &block)
      klass = self.java_class
      while klass
        method = klass.declared_instance_methods.detect do |m|
          (m.name == method_name) and (block_given? ? yield(m) : true)
        end
        return method if method
        klass = klass.superclass
      end
      nil
    end

    def events
      self.event_types.inject({}){|dest, event_type|
        dest[event_type] = event_methods(event_type); dest}
    end

    def event_types
      self.methods.map{|m| /^add\_(.*?)\_listener$/ =~ m ? $1 : nil }.compact.sort
    end

    def event_methods(event_type, *methods)
      listener_interface = listener_interface(event_type)
      listener_interface.declared_instance_methods.map{|method|
        method.name.underscore}
    end

    NULL_METHOD = Proc.new{}

    private
    def build_hash_comparision(options, option_key, method, inverse, comparision_options = nil)
      comparision_options ||= options[option_key]
      return nil unless comparision_options
      "#{option_key.inspect} option must be a hash" unless comparision_options.is_a?(Hash)
      Proc.new do |event|
        matched = comparision_options.send(method){|key, value| event.send(key) == value}
        inverse ? !matched : matched
      end
    end

    def build_listener_filters(options)
      filters = []
      [:if, :unless].each do |condition|
        [:any, :all].each do |joiner|
          filters << build_hash_comparision(options,
            "#{condition.to_s}_#{joiner.to_s}".to_sym,
            "#{joiner.to_s}?", condition == :unless)
        end
      end
      if filters.empty?
        filters << build_hash_comparision(options, :if, :all?, false) if options[:if]
        filters << build_hash_comparision(options, :unless, :all?, true) if options[:unless]
      end
      unless filters.empty? and options.empty?
        filters << build_hash_comparision(nil, :if, :all?, false, options)
      end
      filters.compact!
      filters
    end

    public
    def listen(event_type, *methods, &block)
      options = methods.last.is_a?(Hash) ? methods.pop : {}
      filters = build_listener_filters(options)
      listener_block = filters.empty? ? block :
        Proc.new do |event|
          block.call(event) if filters.all?{|filter| filter.call(event)}
        end

      listener_interface = listener_interface(event_type)
      lister_methods = listener_interface.declared_instance_methods.map{|method| method.name}
      handling_methods = methods.empty? ?
        lister_methods :
        methods.map{|method| invokable_method(lister_methods, event_type, method)}.compact
      mod = Module.new do
        lister_methods.each do |listener_method|
          if handling_methods.include?(listener_method)
            define_method(listener_method){|*args| listener_block.call(*args)}
          else
            define_method(listener_method, &NULL_METHOD)
          end
        end
      end
      method_name = "add#{event_type.to_s.camelize}Listener"
      listener = Object.new
      listener.extend(mod)
      send(method_name, listener)
      listener
    end

    private
    def listener_interface(event_type)
      java_event_name = event_type.to_s.camelize
      method_name = "add#{java_event_name}Listener"
      java_method =
        find_java_method(method_name){|m|m.parameter_types.length == 1} ||
        find_java_method(method_name)
      raise "unsupported event '#{java_event_name}' for #{self.class.name}" unless java_method
      if java_method.parameter_types.length != 1
        method_name = "%s(%s)" % [java_method.name, java_method.parameter_types.map{|t|t.name}.join(',')]
        raise "unsupported evnet method #{method_name} for #{java_method.declaring_class.name}"
      end
      java_method.parameter_types.first
    end

    def invokable_method(java_methods, base_event_type, base_name)
      base_name = base_name.to_s
      return base_name if java_methods.include?(base_name)
      s = self.class.uncapitalize(base_name)
      return s if java_methods.include?(s)
      s = self.class.uncapitalize(base_name.camelize)
      return s if java_methods.include?(s)
      even_type = self.class.uncapitalize(base_event_type.to_s.camelize)
      s = "#{even_type}#{base_name}"
      return s if java_methods.include?(s)
      s = "#{even_type}#{base_name.camelize}"
      return s if java_methods.include?(s)
      return nil
    end
  end
end
