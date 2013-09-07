require 'minitest_helper'

# Test for Rubeus::Extensions::Javax::Swing
class TestJComponent < MiniTest::Test
  include Rubeus::Swing

  # setup method
  def setup
  end

  # normal pattern
  def test_normal
    assert_nothing_raised do
      JFrame.new do |f|
        btn = JButton.new("Push!")
        btn.set_preferred_size(200, 300)

        f.set_size(500, 500)
        f.pack

        assert_equal(200, btn.width)
        assert_equal(300, btn.height)

        f.dispose
      end
    end
  end
end
