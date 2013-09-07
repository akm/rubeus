require 'minitest_helper'

# Test for attributes.rb
class TestAttributes < MiniTest::Unit::TestCase
  include Rubeus::Swing

  # setup method
  def setup
  end

  # new with no argument
  def test_default_attributes=
    JFrame.new do |f|
      assert_equal(JFrame.const_get(:EXIT_ON_CLOSE), f.default_close_operation)
      assert_equal(400, f.size.width)
      assert_equal(300, f.size.height)
    end
  end

  # new with argument
  def test_new
    JFrame.new(:title => 'test') do |f|
      assert_equal(JFrame.const_get(:EXIT_ON_CLOSE), f.default_close_operation)
      assert_equal(400, f.size.width)
      assert_equal(300, f.size.height)
      assert_equal('test', f.title)
    end
  end

  # new with argument that overrides default attributes
  def test_new_override
    JFrame.new(:size => "500 x 400") do |f|
      assert_equal(JFrame.const_get(:EXIT_ON_CLOSE), f.default_close_operation)
      assert_equal(500, f.size.width)
      assert_equal(400, f.size.height)
    end
  end

  # new with argument that value is symbol
  def test_new_with_symbol_value
    JFrame.new(:default_close_operation => :DO_NOTHING_ON_CLOSE) do |f|
      assert_equal(JFrame.const_get(:DO_NOTHING_ON_CLOSE), f.default_close_operation)
      assert_equal(400, f.size.width)
      assert_equal(300, f.size.height)
    end
  end

  # new with argument with error
  def test_new_with_attribute_does_not_exist
    assert_raise(ArgumentError) do
      JFrame.new(:illegal_param => "illegal_value") do |f|
      end
    end
  end
end

