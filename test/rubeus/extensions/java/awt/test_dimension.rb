require 'minitest_helper'

# Test for Rubeus::Extensions::Java::Awt
class TestDimension < MiniTest::Unit::TestCase
  include Rubeus::Awt

  # setup method
  def setup
  end

  # create with array size 0
  def test_create_with_array_size_0
    d = Dimension.create([])

    assert_equal(0, d.width)
    assert_equal(0, d.height)
  end

  # create with array size 1
  def test_create_with_array_size_1
    assert_raise(ArgumentError) do
      d = Dimension.create([200])
    end
  end

  # create with array size 2
  def test_create_with_array_size_2
    d = Dimension.create([200, 300])

    assert_equal(200, d.width)
    assert_equal(300, d.height)
  end

  # create with array size 3
  def test_create_with_array_size_3
    assert_raise(ArgumentError) do
      d = Dimension.create([200, 300, 400])
    end
  end

  # create with dimension object
  def test_create_with_dimension
    d = Dimension.create([300, 400])
    d2 = Dimension.create(d)

    assert_equal(d.width, d2.width)
    assert_equal(d.height, d2.height)
  end

  # create with multiply expression
  def test_create_with_multiply expression
    d = Dimension.create("400 x 500")

    assert_equal(400, d.width)
    assert_equal(500, d.height)
  end

  # create with original constructor
  def test_create_with_original_constructor
    d = Dimension.create(600, 350)

    assert_equal(600, d.width)
    assert_equal(350, d.height)
  end
end
