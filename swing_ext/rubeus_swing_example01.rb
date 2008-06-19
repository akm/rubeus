include Java

require "swing_ext"

import 'javax.swing.BoxLayout'
import 'javax.swing.JButton'
import 'javax.swing.JFrame'
import 'javax.swing.JPanel'
import 'javax.swing.JScrollPane'
import 'javax.swing.JTextField'
import 'javax.swing.JTextPane'
import 'javax.swing.JSplitPane'

# JFrameなどのコンテナのnewに渡されたブロックの中でnewされたコンポーネントは
# 自動的にaddされます。
JFrame.new("Rubeus Swing Example 01") do |frame|
  frame.layout =  BoxLayout.new(frame.content_pane, BoxLayout::Y_AXIS)
  JSplitPane.new(JSplitPane::VERTICAL_SPLIT) do
    JPanel.new do |panel|
      panel.layout = BoxLayout.new(panel, BoxLayout::X_AXIS)
      # キーのイベントもメソッドを指定してハンドリングできます。
      # newにブロックを渡すとlisten(:key, :pressed)が実行されます。
      @text_field = JTextField.new do |event|
        if event.key_code == 10 # RETURN
          @textpane.text += @text_field.text + "\n"
          @text_field.text = ''
        end
      end
=begin
      # 以下のように書くこともできますです
      @text_field = JTextField.new
      @text_field.listen(:key, :key_pressed, :key_code => 10) do |event|
        @textpane.text += @text_field.text + "\n"
        @text_field.text = ''
      end
=end
      JButton.new("append") do
        @textpane.text += @text_field.text
        @text_field.text = ''
      end
    end
    JScrollPane.new do |pane|
      pane.set_preferred_size(400, 250)
      @textpane = JTextPane.new
    end
  end

  frame.set_size(400, 300)
  frame.default_close_operation = JFrame::EXIT_ON_CLOSE
  frame.visible = true
end
