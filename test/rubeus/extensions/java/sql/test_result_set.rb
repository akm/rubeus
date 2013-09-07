require 'minitest_helper'

require 'test/rubeus/extensions/java/sql/test_sql_helper'

# Test for result_set.rb
class TestResultSet < MiniTest::Unit::TestCase
  include TestSqlHelper
  
  def setup
    setup_connection
    @con.statement do |stmt|
      create_table_after_drop("CREATE TABLE TEST (ID INT, NAME CHAR(10))", stmt)
      stmt.execute_update("INSERT INTO TEST VALUES(1, 'row1')")
      stmt.execute_update("INSERT INTO TEST VALUES(2, 'row2')")
    end
  end

  def test_each
    @con.query("SELECT * FROM TEST ORDER BY ID") do |rs|
      i = 1
      rs.each do |rsNext|
        assert_equal(i, rsNext.get_int("ID"))
        assert_equal("row#{i}      ", rsNext.get_string("NAME"))
        i += 1
      end
    end
  end

  def test_each_array
    @con.query("SELECT * FROM TEST ORDER BY ID") do |rs|
      i = 1
      rs.each_array do |rsNext|
        assert_equal(i, rsNext[0])
        assert_equal("row#{i}      ", rsNext[1])
        i += 1
      end
    end
  end

  def test_each_hash
    @con.query("SELECT * FROM TEST ORDER BY ID") do |rs|
      i = 1
      rs.each_hash do |rsNext|
        assert_equal(i, rsNext["ID"])
        assert_equal("row#{i}      ", rsNext["NAME"])
        i += 1
      end
    end
  end

  def teardown
    teardown_connection
  end
end
