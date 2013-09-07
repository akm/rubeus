require 'minitest_helper'

require 'test/rubeus/extensions/java/sql/test_sql_helper'

# Test for statement.rb
class TestStatement < MiniTest::Unit::TestCase
  include TestSqlHelper

  def setup
    setup_connection
  end

  def test_query
    # Drop test table
    begin
      @con.statement do |stmt|
        stmt.execute_update("DROP TABLE TEST")
      end
    rescue
      # table test is already exist
    end

    @con.statement do |stmt|
      stmt.execute_update("CREATE TABLE TEST (ID INT, NAME CHAR(10))")
      stmt.execute_update("INSERT INTO TEST VALUES(1, 'row1')")
      stmt.execute_update("INSERT INTO TEST VALUES(2, 'row2')")

      stmt.query("SELECT * FROM TEST ORDER BY ID") do |rs|
        i = 1
        rs.each_hash do |rsNext|
          assert_equal(i, rsNext["ID"])
          assert_equal("row#{i}      ", rsNext["NAME"])

          i += 1
        end
      end
    end
  end

  def teardown
    teardown_connection
  end
end

