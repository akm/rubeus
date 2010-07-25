require 'rubygems'
require "rubeus"

Rubeus::Swing.irb

JFrame.new("Rubeus Swing Example 01") do |frame|
  frame.layout = BoxLayout.new(:Y_AXIS)
  JSplitPane.new(JSplitPane::VERTICAL_SPLIT) do
    JPanel.new do |panel|
      panel.layout = BoxLayout.new(:X_AXIS)
      @text_field = JTextField.new do |event|
        if event.key_code == 10 # RETURN
          @textpane.text += @text_field.text + "\n"
          @text_field.text = ''
        end
      end
      JButton.new("append") do
        @textpane.text += @text_field.text
        @text_field.text = ''
      end
    end
    JScrollPane.new(:preferred_size => [400, 250]) do |pane|
      @textpane = JTextPane.new
    end
  end
  frame.visible = true
end
