require "rubeus/swing/j_component"
require "rubeus/swing/nestable"
require "rubeus/swing/event"

module Rubeus
  module Swing
    def self.register_as_container(*args, &block)
      Rubeus::Swing::Nestable::Context.register_as_container(*args, &block)
    end
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


JavaUtilities.extend_proxy('javax.swing.JComponent') do
  include Rubeus::Swing::JComponent
end


JavaUtilities.extend_proxy('java.awt.Component') do
  include Rubeus::Swing::Nestable
  include Rubeus::Swing::Event
end

JavaUtilities.extend_proxy("javax.swing.JTextField") do
  def self.default_event_type
    return :key, :pressed
  end
end

JavaUtilities.extend_proxy('javax.swing.JScrollPane') do
  def self.add_new_component_to(object, &block)
    Rubeus::Swing::Nestable::Context.add_new_component_to(object.viewport, :set_view, object, &block)
  end
end

JavaUtilities.extend_proxy('javax.swing.JSplitPane') do
  def self.add_new_component_to(object, &block)
    Rubeus::Swing::Nestable::Context.add_new_component_to(object, :append_component, &block)
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

