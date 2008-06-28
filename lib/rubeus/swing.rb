default_required = %w(nestable event j_component)
default_required.each{|path| require "rubeus/swing/#{path}"}

module Rubeus
  module Swing
    def self.register_as_container(*args, &block)
      Rubeus::Swing::Nestable::Context.register_as_container(*args, &block)
    end
    
    def self.irb
      Object.send(:extend, self)
    end
    
    def const_missing(java_class_name)
      Rubeus::Swing.const_get(java_class_name)
    end

    def self.const_missing(java_class_name)
      attach_component(java_class_name)
    rescue
      super
    end
    
    def self.attach_component(java_class_name)
      full_java_name = "javax.swing.#{java_class_name}"
      self.const_set(java_class_name, instance_eval(full_java_name))
    end
  end
end

base_path = File.dirname(File.dirname(__FILE__))
swing_path = File.join(File.dirname(__FILE__), "swing")

Dir.glob("#{swing_path}/*.rb") do |file|
  unless default_required.any?{|path| file.include?(path)}
    rel_path = file.gsub("#{base_path}/", '')
    base_name = File.basename(rel_path, '.*')
    Rubeus::Swing.autoload(base_name.camelize, rel_path)
  end
end


Rubeus::Swing.register_as_container(
  'javax.swing.JApplet',
  'javax.swing.JFrame',
  'javax.swing.JPanel',
  'javax.swing.JScrollPane',
  'javax.swing.JSplitPane',
  'javax.swing.JWindow'
  )

JavaUtilities.extend_proxy('java.awt.Component') do
  include Rubeus::Swing::Nestable
  include Rubeus::Swing::Event
end

JavaUtilities.extend_proxy('javax.swing.JComponent') do
  include Rubeus::Swing::JComponent
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

