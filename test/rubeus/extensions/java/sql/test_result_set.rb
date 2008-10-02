require 'test/unit'
require 'rubygems'
require 'rubeus'

# Test for result_set.rb
class TestResultSet < Test::Unit::TestCase
  # setup method
  def setup
    @con = Rubeus::Jdbc::DriverManager.connect("jdbc:derby:test_db;create = true", "", "")

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
    @con.close
  end
end

