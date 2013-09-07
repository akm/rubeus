# -*- coding: utf-8 -*-
require 'minitest_helper'

# Test for j_split_pane.rb
class TestJSplitPane < MiniTest::Test
  include Rubeus::Swing

  # setup method
  def setup
  end

  # normal pattern with Symbol
  def test_normal_with_symbol
    assert_nothing_raised do
      JFrame.new do |f|
        JSplitPane.new(:HORIZONTAL_SPLIT) do
          JButton.new("Push!")
          JLabel.new("ラベル")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JSplitPane.new(:VERTICAL_SPLIT) do
          JButton.new("Push!")
          JLabel.new("ラベル")
        end
      end
    end
  end

  # normal pattern with original constructor
  def test_normal_with_original_constructor
    assert_nothing_raised do
      JFrame.new do |f|
        JSplitPane.new(javax.swing.JSplitPane::HORIZONTAL_SPLIT) do
          JButton.new("Push!")
          JLabel.new("ラベル")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JSplitPane.new(javax.swing.JSplitPane::VERTICAL_SPLIT) do
          JButton.new("Push!")
          JLabel.new("ラベル")
        end
      end
    end
  end
end
