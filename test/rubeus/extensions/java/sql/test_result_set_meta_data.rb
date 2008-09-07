require 'test/unit'
require 'rubygems'
require 'rubeus'

# Test for result_set_meta_data.rb
class TestResultSetMetaData < Test::Unit::TestCase
  # setup method
  def setup
    @con = Rubeus::Jdbc::DriverManager.connect("jdbc:derby:test;create = true", "", "")

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
    end
  end

  def test_each_without_block
    @con.query("SELECT * FROM TEST ORDER BY ID") do |rs|
      assert_nil(rs.meta_data.each)
    end
  end

  def test_each_with_block
    @con.query("SELECT * FROM TEST ORDER BY ID") do |rs|
      i = 1
      rs.meta_data.each do |rsMeta|
        assert_equal(i, rsMeta)
        i += 1
      end
    end
  end

  def test_columns
    @con.query("SELECT * FROM TEST ORDER BY ID") do |rs|
      i = 1
      rs.meta_data.columns.each do |column|
        if i == 1
          assert_equal("java.lang.Integer", column.column_class_name)
          assert_equal("java.lang.Integer", column.class_name)
          assert_equal(11, column.column_display_size)
          assert_equal(11, column.display_size)
          assert_equal("ID", column.column_label)
          assert_equal("ID", column.label)
          assert_equal("ID", column.column_name)
          assert_equal("ID", column.name)
          assert_equal("INTEGER", column.column_type_name)
          assert_equal("INTEGER", column.type_name)
          assert_equal(false, column.case_sensitive)
          assert_equal(false, column.case_sensitive?)
          assert_equal(true, column.signed)
          assert_equal(true, column.signed?)
        elsif i == 2
          assert_equal("java.lang.String", column.column_class_name)
          assert_equal("java.lang.String", column.class_name)
          assert_equal(10, column.column_display_size)
          assert_equal(10, column.display_size)
          assert_equal("NAME", column.column_label)
          assert_equal("NAME", column.label)
          assert_equal("NAME", column.column_name)
          assert_equal("NAME", column.name)
          assert_equal("CHAR", column.column_type_name)
          assert_equal("CHAR", column.type_name)
          assert_equal(true, column.case_sensitive)
          assert_equal(true, column.case_sensitive?)
          assert_equal(false, column.signed)
          assert_equal(false, column.signed?)
        end

        # common test
        assert_equal(i, column.column_index)
        assert_equal(i, column.index)
        assert_equal(false, column.auto_increment)
        assert_equal(false, column.auto_increment?)
        assert_equal(false, column.currency)
        assert_equal(false, column.currency?)
        assert_equal(false, column.definitely_writable)
        assert_equal(false, column.definitely_writable?)

        # java.sql.ResultSetMetaData.const_get(:columnNullable) has error
        assert_equal(1, column.is_nullable)

        assert_equal(false, column.read_only)
        assert_equal(false, column.read_only?)
        assert_equal(true, column.searchable)
        assert_equal(true, column.searchable?)
        assert_equal(false, column.writable)
        assert_equal(false, column.writable?)

        i += 1
      end
    end
  end

  def test_column_names
    expected_column_names = {1 => "ID", 2 => "NAME"}
    @con.query("SELECT * FROM TEST ORDER BY ID") do |rs|
      assert_equal(expected_column_names, rs.meta_data.column_names)
    end
  end

  def test_column_index
    @con.query("SELECT * FROM TEST ORDER BY ID") do |rs|
      rs.meta_data.each do |rsMeta|
        assert_equal(rsMeta, rs.meta_data.column_index(rsMeta))
      end
    end
  end

  def teardown
    @con.close
  end
end

