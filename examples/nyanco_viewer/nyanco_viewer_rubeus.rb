#!/usr/bin/env jruby
#
# にゃんこびゅーあー Rubeus
#
# 2008/7/7 Junya Murabe (Lancard.com)
#

include Java

# $LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'rubygems'

require 'rubeus'
Rubeus::Swing.irb
require File.join(File.dirname(__FILE__), 'nyanco_disp_label')

JFrame.new('にゃんこびゅーあー Rubeus ' + Rubeus::VERSION) do |frame|
  frame.set_size 400, 300
  frame.default_close_operation = JFrame::EXIT_ON_CLOSE
  frame.icon_image = ImageIcon.new(File.join(File.dirname(__FILE__), 'nekobean_s.png')).image

  JPanel.new do |base_pane|
    base_pane.layout = BorderLayout.new
    JScrollPane.new do |sp|
      layout = FlowLayout.new
      layout.alignment = FlowLayout::LEFT
      sp.viewport.layout = layout

      lb = NyancoDispLabel.new

      #ドラッグ&ドロップを有効に
      [lb, sp].each do |dt|
        DropTarget.new dt, lb
        dt.tool_tip_text = 'にゃんこの画像をここにポイッ♪'
      end
    end
  end

  frame.visible = true
end
