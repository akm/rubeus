require 'rubygems'
require 'java'
require 'rubeus'

# Rubeus.verbose = true
Rubeus::Swing.irb

JFrame.new('Hello') do |frame|
  frame.layout = BoxLayout.new(:Y_AXIS)

  JSplitPane.new(JSplitPane::HORIZONTAL_SPLIT) do
    JTree.new
    JEditorPane.new
  end
  
  frame.jmenu_bar = JMenuBar.new do
    JMenu.new("File") do
      JMenuItem.new("New...") do
        puts 'new'
      end
      JMenuItem.new("Exit") do
        java.lang.System.exit(0)
      end
    end
  end

  frame.set_size(800, 600)
  frame.default_close_operation = JFrame::EXIT_ON_CLOSE
  frame.visible = true
end
