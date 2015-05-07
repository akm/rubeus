require 'minitest_helper'

# Test for setter.rb
class TestSetter < MiniTest::Test
  include Rubeus::Swing

  # setup method
  def setup
  end

  # test set_preferred_size
  def test_set_preferred_size
    JFrame.new do |f|
      txt = JTextField.new
      txt.set_preferred_size "100 x 150"

      f.pack

      assert_equal(100, txt.get_preferred_size.width)
      assert_equal(150, txt.get_preferred_size.height)

      f.dispose
    end
  end

  # test preferred_size=
  def test_preferred_size=
    JFrame.new do |f|
      txt = JTextField.new
      txt.preferred_size = "150 x 100"

      f.pack

      assert_equal(150, txt.preferred_size.width)
      assert_equal(100, txt.preferred_size.height)

      f.dispose
    end
  end
end
