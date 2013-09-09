require 'minitest_helper'

require 'test/rubeus/extensions/java/sql/test_sql_helper'

# Test for connetion.rb
class TestConnection < MiniTest::Test
  include TestSqlHelper

  # def setup   ; setup_connection   ; end
  # def teardown; teardown_connection; end

  def setup
    setup_connection
    @con.auto_commit = false
  end
  def teardown
    @con.rollback
    teardown_connection
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

  def test_insert_from_csv_integer
    @con.statement do |stmt|
      # no tinyint on derby
      # http://db.apache.org/derby/docs/10.1/ref/crefsqlj31068.html
      # create_table_after_drop("CREATE TABLE INTEGER_TABLE1 (id SMALLINT, tinyint1 TINYINT, smallint1 SMALLINT, int1 INTEGER, bigint1 BIGINT)", stmt)
      create_table_after_drop("CREATE TABLE INTEGER_TABLE1 (id SMALLINT, smallint1 SMALLINT, int1 INTEGER, bigint1 BIGINT)", stmt)
      @con.import_csv(File.expand_path("../test_connection/integer_table1.csv", __FILE__), into: "INTEGER_TABLE1")
    end
    @con.query("SELECT * FROM INTEGER_TABLE1 ORDER BY ID") do |q|
    assert_equal([
      [1, nil, nil, nil],
      [2, nil, nil, nil],
      [3, 1, 2, 3,],
      [4, 1, 2, 3,],
      [5, 1, 2, 3,],
      [6, 1, 2, 3,],
      [7, 1, 2, 3,],
      [8, 1, 2, 3,],
    ], q.to_arrays)
    end
  end

  def test_insert_from_csv_real
    @con.statement do |stmt|
      #
      # The DOUBLE data type is a synonym for the DOUBLE PRECISION data type.
      # The FLOAT data type is an alias for a REAL or DOUBLE PRECISION data type, depending on the precision you specify.
      # NUMERIC is a synonym for DECIMAL and behaves the same way
      create_table_after_drop("CREATE TABLE REAL_TABLE1 (id SMALLINT, decimal1 DECIMAL(5,2), double1 DOUBLE, float1 FLOAT, real1 REAL)", stmt)
      @con.import_csv(File.expand_path("../test_connection/real_table1.csv", __FILE__), into: "REAL_TABLE1")
    end
    @con.query("SELECT * FROM REAL_TABLE1 ORDER BY ID") do |q|
      expects = [
        [1, nil, nil, nil, nil],
        [2, nil, nil, nil, nil],
        [3, java.math.BigDecimal.new(1.0), 2.0, 3.0, 4.0],
        [4, java.math.BigDecimal.new(1.0), 2.0, 3.0, 4.0],
        [5, java.math.BigDecimal.new(1.0), 2.0, 3.0, 4.0],
        [6, java.math.BigDecimal.new(1.0), 2.0, 3.0, 4.0],
        [7, java.math.BigDecimal.new(1.0), 2.0, 3.0, 4.0],
        [8, java.math.BigDecimal.new(1.0), 2.0, 3.0, 4.0],
      ]
      actuals = q.to_arrays
      expects.each.with_index do |expect, idx|
        assert_equal(
               expect.map{|ex| ex.respond_to?(:doubleValue) ? ex.doubleValue : ex},
               actuals[idx].map{|a| a.respond_to?(:doubleValue) ? a.doubleValue : a}
               )
      end
    end
  end

  def test_insert_from_csv_string
    @con.statement do |stmt|
      create_table_after_drop("CREATE TABLE STRING_TABLE1 (id SMALLINT, char1 CHAR(5), varchar1 VARCHAR(6))")
      @con.import_csv(File.expand_path("../test_connection/string_table1.csv", __FILE__))
    end
    @con.query("SELECT * FROM STRING_TABLE1 ORDER BY ID") do |q|
    assert_equal([
      [1, nil, nil],
      [2, nil, nil],
      [3, "abcde", "abcdef"],
      [4, "abc  ", "abc"],
      [5, "abcde", "abcdef"],
      [6, "abc  ", "abc"],
      [7, "abcde", "abcdef"],
      [8, "abc  ", "abc"],
    ], q.to_arrays)
    end
  end

  # def test_insert_from_csv_datetime
  #   @con.statement do |stmt|
  #     create_table_after_drop("CREATE TABLE DATETIME_TABLE1 (id SMALLINT, date1 DATE, time1 TIME, timestamp1 TIMESTAMP)")
  #     @con.import_csv(File.expand_path("../test_connection/datetime_table1.csv", __FILE__))
  #   end
  #   @con.auto_commit = false
  #   @con.query("SELECT * FROM DATETIME_TABLE1 ORDER BY ID").to_arrays.should == [
  #     [1, nil, nil, nil, nil],
  #     [2, nil, nil, nil, nil],
  #     [3, ],
  #   ]
  # end
end
