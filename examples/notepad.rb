include Java

require 'rubygems'
gem 'rubeus'
require 'rubeus'

Rubeus::Swing.irb

import 'java.io.FileInputStream'
import 'java.io.FileOutputStream'
import 'javax.swing.text.DefaultStyledDocument'
import 'javax.swing.text.StyleContext'
import 'javax.swing.text.rtf.RTFEditorKit'

rtf_editor_kit = RTFEditorKit.new

JFrame.new('Notepad') do |frame|
	JScrollPane.new do |pane|
		pane.vertical_scroll_bar_policy = ScrollPaneConstants::VERTICAL_SCROLLBAR_AS_NEEDED
		pane.horizontal_scroll_bar_policy = ScrollPaneConstants::HORIZONTAL_SCROLLBAR_NEVER
		@text_pane = JTextPane.new
		@text_pane.document = DefaultStyledDocument.new StyleContext.new
	end

	rtf_editor_kit.read FileInputStream.new('notepad.rtf'), @text_pane.document, 0
	
	@text_pane.listen(:key, :key_released) do |event|
		rtf_editor_kit.write FileOutputStream.new('notepad.rtf'), @text_pane.document, 0, @text_pane.document.length
	end

	frame.default_close_operation = JFrame::EXIT_ON_CLOSE
	frame.set_size(300, 200)
	frame.set_location_relative_to(nil)
	frame.visible = true
end
