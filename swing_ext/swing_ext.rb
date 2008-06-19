JavaUtilities.extend_proxy('java.awt.Component') do
  def self.new_with_nestable(*args, &block)
    object = self.new_without_nestable(*args)
    @@container ||= nil
    @@container.add(object) if @@container
    return object unless block_given?
    initial_nest(object, &block)
    return object
  end
  
  self.instance_eval do
    alias :new_without_nestable :new
    alias :new :new_with_nestable
  end
  
  def self.initial_nest(object, &block)
    if object.respond_to?(:listen)
      object.listen(*self.default_event_type, &block)
    else
      raise "#{self.name} doesn't support initial_nest"
    end
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
  
  def listen(event_type, *methods, &block)
    listener_interface = listener_interface(event_type)
    lister_methods = listener_interface.declared_instance_methods.map{|method| method.name}
    handling_methods = methods.empty? ?
      lister_methods :
      methods.map{|method| invokable_method(lister_methods, event_type, method)}.compact
    mod = Module.new do
      lister_methods.each do |listener_method|
        if handling_methods.include?(listener_method) 
          define_method(listener_method){|*args| block.call(*args)}
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


container_swing_classes = [
  'javax.swing.JApplet',
  'javax.swing.JDesktopPane',
  'javax.swing.JFrame',
  'javax.swing.JLayeredPane',
  'javax.swing.JPanel',
  'javax.swing.JWindow'
]
container_swing_classes.each do |container_swing_class|
  JavaUtilities.extend_proxy(container_swing_class) do
    def self.initial_nest(object, &block)
      former_container = @@container
      @@container = object
      begin
        yield(object)
      ensure
        @@container = former_container
      end
    end
  end
end



JavaUtilities.extend_proxy("javax.swing.JTextField") do
  def self.default_event_type
    return :key, :pressed
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

frame.events.each do |event|
  puts "#{event} => #{frame.event_methods(event).inspect}"
end

frame.visible = true

=end

