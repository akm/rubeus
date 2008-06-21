class << java.swing
  def container_class_names
    @container_class_names ||= []
  end
  
  def container_class_names=(*class_names)
    @container_class_names = class_names
  end
  
  def register_as_container(*class_names)
    self.container_class_names.concat(class_names)
  end
  
  def add_component_if_container_exist(component, &block)
    @container ||= nil
    @container.send(@action, component) if @container
  end
  
  def add_new_component_to(container, action = :add, block_argument = nil, &block)
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
end


java.swing.register_as_container(
  'javax.swing.JApplet',
  'javax.swing.JFrame',
  'javax.swing.JPanel',
  'javax.swing.JScrollPane',
  'javax.swing.JSplitPane',
  'javax.swing.JWindow'
  )

JavaUtilities.extend_proxy('javax.swing.JComponent') do
  def set_preferred_size_with_rubeus(*args)
    values = args
    if args.length == 1
      if args.first.is_a?(java.awt.Dimension)
        return set_preferred_size_without_rubeus(*args)
      else
        values = args.first.to_s.split("x", 2)
      end
    end
    set_preferred_size_without_rubeus(java.awt.Dimension.new(*values.map{|s|s.to_i}))
  end
  
  alias_method :set_preferred_size_without_rubeus, :set_preferred_size
  alias_method :set_preferred_size, :set_preferred_size_with_rubeus
end


JavaUtilities.extend_proxy('java.awt.Component') do
  def self.new_with_nestable(*args, &block)
    object = self.new_without_nestable(*args)
    java.swing.add_component_if_container_exist(object)
    return object unless block_given?
    initial_nest(object, &block)
    return object
  end
  
  self.instance_eval do
    alias :new_without_nestable :new
    alias :new :new_with_nestable
  end
  
  def self.constianer?
    java.swing.container_class_names.include?(self.java_class.name)
  end
  
  def self.perform_as_container
    @as_container = true
  end
  
  def self.perform_as_containee
    @as_container = false
  end
  
  def self.initial_nest(object, &block)
    if self.constianer?
      self.add_new_component_to(object, &block)
    elsif object.respond_to?(:listen)
      object.listen(*self.default_event_type, &block)
    else
      raise "#{self.java_class.name} doesn't support initial_nest"
    end
  end

  def self.add_new_component_to(object, &block)
    java.swing.add_new_component_to(object, &block)
  end
  
  def self.default_event_type
    :action
  end
  
  def self.camelize(str)
    parts = str.to_s.split('_')
    parts.map{|part| part[0..0].upcase + part[1..-1].downcase}.join
  end
  
  def self.underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end
  
  def self.uncapitalize(str)
    str[0..0].downcase + str[1..-1]
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
      self.class.underscore(method.name)}
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
    method_name = "add#{self.class.camelize(event_type)}Listener"
    listener = Object.new
    listener.extend(mod)
    send(method_name, listener)
    listener
  end

  private
  def listener_interface(event_type)
    java_event_name = self.class.camelize(event_type)
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
    s = self.class.uncapitalize(self.class.camelize(base_name))
    return s if java_methods.include?(s)
    even_type = self.class.uncapitalize(self.class.camelize(base_event_type))
    s = "#{even_type}#{base_name}"
    return s if java_methods.include?(s)
    camelized = self.class.camelize(base_name)
    s = "#{even_type}#{camelized}"
    return s if java_methods.include?(s)
    return nil
  end
end

JavaUtilities.extend_proxy("javax.swing.JTextField") do
  def self.default_event_type
    return :key, :pressed
  end
end

JavaUtilities.extend_proxy('javax.swing.JScrollPane') do
  def self.add_new_component_to(object, &block)
    java.swing.add_new_component_to(object.viewport, :set_view, object, &block)
  end
end

JavaUtilities.extend_proxy('javax.swing.JSplitPane') do
  def self.add_new_component_to(object, &block)
    java.swing.add_new_component_to(object, :append_component, &block)
  end
  
  def append_component(component)
    append_method =
      (self.orientation == javax.swing.JSplitPane::VERTICAL_SPLIT) ?
        (top_component ? :set_bottom_component : :set_top_component) :
        (left_component ? :set_right_component : :set_left_component)
    send(append_method, component)
  end
  
end



=begin
import "javax.swing.JFrame"

require "swing_ext"

frame = JFrame.new("JDBC Query")
frame.set_size(400, 300)
frame.default_close_operation = JFrame::EXIT_ON_CLOSE
frame.events
frame.event_methods(:key)
frame.event_methods(:key, :typed)
frame.event_methods(:key, "typed")
frame.event_methods(:key, :keyTyped)
frame.event_methods(:key, :keyTyped)
frame.event_methods(:key, "key_typed")
frame.event_methods(:key, "key_Typed")

frame.events.each

frame.visible = true

=end

