#!/usr/bin/env jruby
#
# にゃんこびゅーあー Rubeus 0.0.3
#
# 2008/7/3 Junya Murabe (Lancard.com)
#

include Java

require 'rubygems'
gem 'rubeus', '=0.0.4'
require 'rubeus'
Rubeus::Swing.irb

JFrame.new('にゃんこびゅーあー Rubeus') do |frame|
  frame.set_size 400, 300
  frame.default_close_operation = JFrame::EXIT_ON_CLOSE
  frame.icon_image = ImageIcon.new(File.join(File.dirname(__FILE__), 'nekobean_s.png')).image

  JPanel.new do |base_pane|
    base_pane.layout = java.awt.BorderLayout.new
    JScrollPane.new do |sp|
      layout = java.awt.FlowLayout.new
      layout.alignment = java.awt.FlowLayout::LEFT
      sp.viewport.layout = layout

      require File.join(File.dirname(__FILE__), 'nyanco_disp_label')
      lb = NyancoDispLabel.new

      #ドラッグ&ドロップを有効に
      [lb, sp].each do |dt|
        java.awt.dnd.DropTarget.new dt, lb
        dt.tool_tip_text = 'にゃんこの画像をここにポイッ♪'
      end
    end
  end

  frame.visible = true
end
