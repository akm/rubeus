require 'minitest_helper'

# Test for timer.rb
class TestTimer < MiniTest::Unit::TestCase
  include Rubeus::Swing

  # setup method
  def setup
  end

  # normal pattern
  def test_normal
    skip "FIXME!"

    count = 0
    t = Timer.new(100) do
      count += 1
    end
    t.start

    sleep(1)

    assert_operator(count, :>=, 1)

    t.stop
  end
end

