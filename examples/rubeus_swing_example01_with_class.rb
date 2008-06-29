include Java

require 'rubygems'
gem "rubeus"
require "rubeus"

class Example01
  extend Rubeus::Swing
  
  def show
    # JFrameなどのコンテナのnewに渡されたブロックの中でnewされたコンポーネントは
    # 自動的にaddされます。
    JFrame.new("Rubeus Swing Example 01") do |frame|
      frame.layout = BoxLayout.new(:Y_AXIS)
      JSplitPane.new(JSplitPane::VERTICAL_SPLIT) do
        JPanel.new do |panel|
          panel.layout = BoxLayout.new(:X_AXIS)
          # キーのイベントもメソッドを指定してハンドリングできます。
          # newにブロックを渡すとlisten(:key, :pressed)が実行されます。
          @text_field = JTextField.new do |event|
            if event.key_code == 10 # RETURN
              @textpane.text += @text_field.text + "\n"
              @text_field.text = ''
            end
          end
          # 以下のように書くこともできますです
          # @text_field = JTextField.new
          # @text_field.listen(:key, :key_pressed, :key_code => 10) do |event|
          #   @textpane.text += @text_field.text + "\n"
          #   @text_field.text = ''
          # end
          JButton.new("append") do
            @textpane.text += @text_field.text + "\n"
            @text_field.text = ''
          end
        end
        JScrollPane.new(:preferred_size => [400, 250]) do |pane|
          @textpane = JTextPane.new
        end
      end
      frame.visible = true
    end
  end
end
Example01.new.show
