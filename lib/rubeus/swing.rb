require "rubeus/component_loader"

module Rubeus
  extensions_path = File.join(File.dirname(__FILE__), "swing", "extensions")
  Swing = ComponentLoader.new("javax.swing", extensions_path) do
    
    def self.irb
      Object.send(:extend, self)
    end
  end
end

require "rubeus/swing/extensions"

require "rubeus/awt/attributes"
require "rubeus/awt/nestable"
require "rubeus/awt/event"


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

