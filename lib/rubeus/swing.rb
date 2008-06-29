require "rubeus/component_loader"
require "rubeus/awt"

module Rubeus
  Swing = ComponentLoader.new("javax.swing") do
    class_to_package.update(
      # $JAVA_HOME/lib/classlistにないものリスト
      'JTextPane' => 'javax.swing',
      'RTFEditorKit' => 'javax.swing.text.rtf'
      )
    class_to_package['DefaultStyledDocument'] ||= 'javax.swing.text' # Windowsにない
    
    def self.irb
      Object.send(:extend, self)
    end
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

