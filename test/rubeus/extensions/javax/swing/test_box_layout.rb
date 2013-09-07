require 'minitest_helper'

# Test for Rubeus::Extensions::Javax::Swing
class TestBoxLayout < MiniTest::Unit::TestCase
  include Rubeus::Swing

  # setup method
  def setup
  end

  # normal pattern with JFrame
  def test_new_normal_jframe
    assert_nothing_raised do
      JFrame.new do |f|
        f.layout = BoxLayout.new(:Y_AXIS)
      end
    end
  end

  # normal pattern with JPanel
  def test_new_normal_jpanel
    assert_nothing_raised do
      JFrame.new do |f|
        JPanel.new do |p|
          f.layout = BoxLayout.new(:Y_AXIS)
        end
      end
    end
  end

  # new without container
  def test_new_without_container
    assert_raise(ArgumentError) do
      BoxLayout.new(:Y_AXIS)
    end
  end

  # new with various axis
  def test_new_with_various_axis
    assert_nothing_raised do
      JFrame.new do |f|
        f.layout = BoxLayout.new(:X_AXIS)
        f.layout = BoxLayout.new(:Y_AXIS)
        f.layout = BoxLayout.new(:LINE_AXIS)
        f.layout = BoxLayout.new(:PAGE_AXIS)

        f.layout = BoxLayout.new(javax.swing.BoxLayout::X_AXIS)
        f.layout = BoxLayout.new(javax.swing.BoxLayout::Y_AXIS)
        f.layout = BoxLayout.new(javax.swing.BoxLayout::LINE_AXIS)
        f.layout = BoxLayout.new(javax.swing.BoxLayout::PAGE_AXIS)
      end
    end
  end
end
