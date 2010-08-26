# -*- coding: utf-8 -*-
require 'test/unit'
require 'rubygems'
require 'rubeus'

# Test for j_scroll_pane.rb
class TestJScrollPane < Test::Unit::TestCase
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
