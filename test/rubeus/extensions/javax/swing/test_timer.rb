require 'test/unit'
require 'rubygems'
require 'rubeus'

# Test for timer.rb
class TestTimer < Test::Unit::TestCase
  include Rubeus::Swing

  # setup method
  def setup
  end

  # normal pattern
  def test_normal
    count = 0
    t = Timer.new(100) do
      count += 1
    end
    t.start

    sleep(1)

    assert(count > 1)

    t.stop
  end
end

