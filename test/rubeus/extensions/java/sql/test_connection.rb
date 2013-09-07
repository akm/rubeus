require 'minitest_helper'

require 'test/rubeus/extensions/java/sql/test_sql_helper'

# Test for connetion.rb
class TestConnection < MiniTest::Test
  include TestSqlHelper

  def setup
    setup_connection
  end

  def test_statement
    assert_nothing_raised do
      @con.statement do |stmt|
      end
    end
  end

  def test_query
    @con.statement do |stmt|
      create_table_after_drop("CREATE TABLE TEST (ID INT, NAME CHAR(10))", stmt)
      stmt.execute_update("INSERT INTO TEST VALUES(1, 'row1')")
      stmt.execute_update("INSERT INTO TEST VALUES(2, 'row2')")
    end

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
