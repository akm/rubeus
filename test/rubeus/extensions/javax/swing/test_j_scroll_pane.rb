# -*- coding: utf-8 -*-
require 'minitest_helper'

# Test for j_scroll_pane.rb
class TestJScrollPane < MiniTest::Test
  include Rubeus::Swing

  # setup method
  def setup
  end

  # normal pattern
  def test_normal
    assert_nothing_raised do
      JFrame.new do |f|
        JScrollPane.new do |p|
          JButton.new("Push!")
          JLabel.new("ラベル")
        end
      end
    end
  end
end
