require 'minitest_helper'

class TestRubeus < MiniTest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Rubeus::VERSION
  end
end
