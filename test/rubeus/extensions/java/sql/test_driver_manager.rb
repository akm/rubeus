require 'test/unit'
require 'rubygems'
require 'rubeus'

# Test for driver_manager.rb
class TestDriverManager < Test::Unit::TestCase
  # setup method
  def setup
  end

  def test_normal
    assert_nothing_raised do
      @con = Rubeus::Jdbc::DriverManager.connect("jdbc:derby:test_db;create = true", "", "")
    end

    if @con
      assert_equal(false, @con.closed?)
      @con.close
    end
  end

  def test_without_auto_setup_manager
    assert_nothing_raised do
      org.apache.derby.jdbc.EmbeddedDriver
      @con = Rubeus::Jdbc::DriverManager.connect("jdbc:derby:test_db;create = true", "", "", :auto_setup_manager => false)
      @con.close
    end
  end

  def test_with_block
    con = Rubeus::Jdbc::DriverManager.connect("jdbc:derby:test_db;create = true") do |con|
      assert_equal(false, con.closed?)
    end
    assert_nil(con)
  end
end

